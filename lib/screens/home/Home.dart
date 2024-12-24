import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cypheron/models/UserModel.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/services/HiveService.dart';

import 'package:cypheron/ui/screensUI/HomeUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/OpsRowUI.dart';

import 'package:cypheron/widgets/dialogs/ExitConfirmationDialog.dart';
import 'package:cypheron/widgets/search/SearchField.dart';
import 'package:cypheron/widgets/lists/ContactsList.dart';
import 'package:cypheron/widgets/buttons/AddContactButton.dart';

import 'package:cypheron/screens/welcome/Welcome.dart';
import 'package:cypheron/screens/Contact_info/ContactInfo.dart';


class Home extends StatefulWidget {
  final UserModel? user;

  Home({required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ContactModel> contactList = [];
  List<ContactModel> filteredContactList = [];
  bool isSaving = false;
  ContactModel? selectedContact;
  bool isSearching = false; // Tracks if search mode is active
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reset search mode when returning to the Home screen
    if (!isSearching) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isSearching = false; // Exit search mode
          searchQuery = ''; // Clear search query
          filteredContactList = List.from(contactList); // Reset list
        });
      });
    }
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: Scaffold(
        appBar: AppBar(
          title: isSearching
            ? SearchField(
                onChanged: (value) {
                  _filterContacts(value); // Filter contacts as the user types
                },
              )
            : const Text("Cypheron"),

          actions: [
            if (!isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    isSearching = true; // Enter search mode
                  });
                },
              ),
            if (isSearching)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isSearching = false; // Exit search mode
                    searchQuery = ''; // Clear search query
                    filteredContactList = List.from(contactList); // Reset list
                  });
                },
              ),
            if (selectedContact == null && !isSearching)
              IconsUI(
                type: IconType.logout,
                onPressed: () async {
                  await _confirmLogout(); // Show confirmation dialog for logout
                },
              ),
          ],
        ),
        body: HomeUI(
          isSaving: isSaving,
          children: [
            ContactList(
              contactList: filteredContactList,
              onTap: (ContactModel contact) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactInfo(contact: contact),
                  ),
                );
              },
              onLongPress: (ContactModel contact) {
                isSearching = false;
                setState(() {
                  selectedContact = contact; // Enter deletion mode
                });
              },
              selectedContact: selectedContact,
            ),
            if (selectedContact != null)
              OpsRowUI(
                options: [
                  IconsUI(
                    type: IconType.delete,
                    onPressed: () => _deleteContact(selectedContact!),
                  )
                ],
              )
          ],
        ),
        floatingActionButton: selectedContact == null
            ? AddContactButton(onAddContact: _addNewContact)
            : null,
      ),
    );
  }

  /// Handles the back button to either cancel deletion mode or show the exit confirmation dialog
  Future<bool> _handleBackButton() async {
    if (selectedContact != null) {
      setState(() {
        selectedContact = null;
      });
      return false; // Do not exit the app
    }

    if (isSearching) {
      setState(() {
        isSearching = false;
        searchQuery = ''; // Clear search query
        filteredContactList = List.from(contactList); // Reset list
      });
      return false; // Do not exit the app
    }

    return await _confirmLogout();
  }

  /// Filters contacts based on the search query
  void _filterContacts(String query) {
    setState(() {
      searchQuery = query;
      filteredContactList = contactList
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// Shows a confirmation dialog before logging out
  Future<bool> _confirmLogout() async {
    final shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (context) => ExitConfirmationDialog(
        onConfirm: () async {
          Navigator.of(context).pop(true);
        },
      ),
    );

    if (shouldLogOut == true) {
      await _logOut(context); // Log out if confirmed
    }

    return shouldLogOut ?? false;
  }

  Future<void> _logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Welcome()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts;
      filteredContactList = loadedContacts; // Initialize filtered list
    });
  }

  void _addNewContact(ContactModel newContact) {
    if (contactList.any((contact) =>
        contact.name.toLowerCase() == newContact.name.toLowerCase() &&
        contact.phoneNumber == newContact.phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact already exists.')),
      );
      return;
    }

    setState(() {
      contactList.add(newContact);
      filteredContactList = List.from(contactList); // Update filtered list
      isSaving = true;
    });

    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false;
        });
      } else {
        setState(() {
          contactList.remove(newContact);
          filteredContactList = List.from(contactList);
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save contact.')),
        );
      }
    });
  }

  void _deleteContact(ContactModel contactToDelete) {
    setState(() {
      contactList.remove(contactToDelete);
      filteredContactList = List.from(contactList); // Update filtered list
      selectedContact = null;
    });

    HiveService.deleteContact(widget.user!, contactToDelete).then((success) {
      if (!success) {
        setState(() {
          contactList.add(contactToDelete);
          filteredContactList = List.from(contactList);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete contact.')),
        );
      }
    });
  }
}
