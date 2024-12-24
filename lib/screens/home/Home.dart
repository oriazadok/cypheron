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

/// The main Home screen for the app, displaying user contacts.
class Home extends StatefulWidget {
  final UserModel? user; // Represents the currently logged-in user.

  Home({required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ContactModel> contactList = []; // Stores all contacts.
  List<ContactModel> filteredContactList = []; // Stores filtered contacts based on search.
  bool isSaving = false; // Tracks if a save operation is in progress.
  ContactModel? selectedContact; // Tracks the currently selected contact.
  bool isSearching = false; // Tracks if the user is in search mode.
  String searchQuery = ''; // Stores the current search query.

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds); // Load contacts for the logged-in user.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reset search mode when returning to the Home screen.
    if (!isSearching) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isSearching = false; // Exit search mode.
          searchQuery = ''; // Clear search query.
          filteredContactList = List.from(contactList); // Reset to the full contact list.
        });
      });
    }

    return WillPopScope(
      onWillPop: _handleBackButton, // Handles back button behavior.
      child: Scaffold(
        appBar: AppBar(
          // Displays a search bar or the app title based on `isSearching`.
          title: isSearching
            ? SearchField(
                onChanged: (value) {
                  _filterContacts(value); // Updates the filtered contacts.
                },
              )
            : const Text("Cypheron"), // Default app title.

          actions: [
            // Search icon to toggle search mode.
            if (!isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    isSearching = true; // Enter search mode.
                  });
                },
              ),
            // Close icon to exit search mode.
            if (isSearching)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isSearching = false; // Exit search mode.
                    searchQuery = ''; // Clear search query.
                    filteredContactList = List.from(contactList); // Reset list.
                  });
                },
              ),
            // Logout icon, visible only when not in search mode or contact selection.
            if (selectedContact == null && !isSearching)
              IconsUI(
                type: IconType.logout,
                onPressed: () async {
                  await _confirmLogout(); // Logout confirmation dialog.
                },
              ),
          ],
        ),
        body: HomeUI(
          isSaving: isSaving, // Passes the save state to the UI.
          children: [
            // Displays the contact list.
            ContactList(
              contactList: filteredContactList, // Shows filtered or all contacts.
              onTap: (ContactModel contact) {
                // Navigates to contact details when tapped.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactInfo(contact: contact),
                  ),
                );
              },
              onLongPress: (ContactModel contact) {
                // Handles long-press to select a contact.
                isSearching = false;
                setState(() {
                  selectedContact = contact; // Enter deletion mode.
                });
              },
              selectedContact: selectedContact, // Highlights the selected contact.
            ),
            // Displays a row of options (like delete) when a contact is selected.
            if (selectedContact != null)
              OpsRowUI(
                options: [
                  IconsUI(
                    type: IconType.delete,
                    onPressed: () => _deleteContact(selectedContact!), // Deletes the contact.
                  )
                ],
              )
          ],
        ),
        // Floating action button for adding a new contact.
        floatingActionButton: selectedContact == null
            ? AddContactButton(onAddContact: _addNewContact)
            : null,
      ),
    );
  }

  /// Handles back button to cancel deletion mode, exit search, or show logout dialog.
  Future<bool> _handleBackButton() async {
    if (selectedContact != null) {
      setState(() {
        selectedContact = null; // Deselect contact.
      });
      return false; // Prevent app exit.
    }

    if (isSearching) {
      setState(() {
        isSearching = false; // Exit search mode.
        searchQuery = ''; // Clear search query.
        filteredContactList = List.from(contactList); // Reset list.
      });
      return false; // Prevent app exit.
    }

    return await _confirmLogout(); // Show logout confirmation.
  }

  /// Filters contacts based on the user's search query.
  void _filterContacts(String query) {
    setState(() {
      searchQuery = query; // Updates the search query.
      filteredContactList = contactList
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase())) // Filters contacts.
          .toList();
    });
  }

  /// Shows a confirmation dialog before logging out.
  Future<bool> _confirmLogout() async {
    final shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (context) => ExitConfirmationDialog(
        onConfirm: () async {
          Navigator.of(context).pop(true); // Confirms logout.
        },
      ),
    );

    if (shouldLogOut == true) {
      await _logOut(context); // Logs out the user.
    }

    return shouldLogOut ?? false;
  }

  /// Logs the user out and navigates to the Welcome screen.
  Future<void> _logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase logout.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Welcome()), // Redirect to Welcome screen.
        (route) => false,
      );
    } catch (e) {
      // Shows an error message if logout fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  /// Loads contacts from Hive storage based on user-provided IDs.
  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts; // Updates the contact list.
      filteredContactList = loadedContacts; // Initializes the filtered list.
    });
  }

  /// Adds a new contact and saves it to Hive storage.
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
      contactList.add(newContact); // Adds the contact locally.
      filteredContactList = List.from(contactList); // Updates the filtered list.
      isSaving = true; // Indicates a save operation.
    });

    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false; // Save completed.
        });
      } else {
        setState(() {
          contactList.remove(newContact); // Reverts the change on failure.
          filteredContactList = List.from(contactList);
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save contact.')),
        );
      }
    });
  }

  /// Deletes a selected contact and updates the list.
  void _deleteContact(ContactModel contactToDelete) {
    setState(() {
      contactList.remove(contactToDelete); // Removes the contact locally.
      filteredContactList = List.from(contactList); // Updates the filtered list.
      selectedContact = null; // Clears the selected contact.
    });

    HiveService.deleteContact(widget.user!, contactToDelete).then((success) {
      if (!success) {
        setState(() {
          contactList.add(contactToDelete); // Reverts the change on failure.
          filteredContactList = List.from(contactList);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete contact.')),
        );
      }
    });
  }
}
