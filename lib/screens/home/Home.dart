import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication for user login/logout

import 'package:cypheron/models/UserModel.dart'; // Represents the structure of a user
import 'package:cypheron/models/ContactModel.dart'; // Represents the structure of a contact
import 'package:cypheron/services/HiveService.dart'; // Handles local data storage using Hive

import 'package:cypheron/ui/screensUI/HomeUI.dart'; // UI layout for the Home screen
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart'; // Utility for reusable icons in the app

import 'package:cypheron/widgets/lists/ContactsList.dart'; // Widget to display the list of contacts
import 'package:cypheron/widgets/buttons/AddContactButton.dart'; // Floating action button for adding contacts
import 'package:cypheron/widgets/dialogs/ExitConfirmationDialog.dart'; // Reusable dialog widget for confirmation prompts

import 'package:cypheron/screens/welcome/Welcome.dart'; // Welcome screen for user redirection after logout

/// The Home screen of the app, which displays a list of user contacts.
/// This is a stateful widget because it manages user interactions and dynamic data.
class Home extends StatefulWidget {
  final UserModel? user; // Represents the logged-in user

  /// Constructor requires the `user` object
  Home({required this.user});

  @override
  _HomeState createState() => _HomeState();
}

/// The state class for the Home screen
class _HomeState extends State<Home> {
  List<ContactModel> contactList = []; // Stores the list of contacts
  bool isSaving = false; // Indicates whether a save operation is in progress
  bool isOnLongPress = false; // Tracks if a long press is active

  @override
  void initState() {
    super.initState();
    // Load contacts when the screen initializes, if a user is provided
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handles the back button behavior
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Cypheron"), // App title in the AppBar
          actions: [
            // Logout button in the AppBar
            IconsUI(
              type: IconType.logout, // Custom logout icon
              onPressed: () async {
                await _onWillPop(); // Trigger back button logic
              },
            ),
          ],
        ),
        body: HomeUI(
          isSaving: isSaving, // Displays a loading state if saving
          contactList: ContactList(
            contactList: contactList, // Pass the list of contacts to display
            onDelete: (ContactModel contact) {
              _deleteContact(contact); // Handles contact deletion
            },
            onLongPress: () {
              // Toggles the long press state
              setState(() {
                isOnLongPress = !isOnLongPress;
              });
            },
          ),
        ),
        floatingActionButton: !isOnLongPress
            ? AddContactButton(onAddContact: _addNewContact) // Add contact button
            : null,
      ),
    );
  }

  /// Handles the back button behavior by showing a confirmation dialog
  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => ExitConfirmationDialog(
        onConfirm: () async => await _logOut(context), // Calls logout logic on confirmation
      ),
    );
    return shouldPop ?? false; // Prevents exiting by default
  }

  /// Logs the user out by signing out from Firebase and navigating to the Welcome screen
  Future<void> _logOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Logs out from Firebase
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Welcome()), // Redirects to Welcome screen
        (route) => false, // Removes all previous routes
      );
    } catch (e) {
      // Shows an error message if sign-out fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  /// Loads the contacts from Hive storage using their IDs
  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts; // Updates the contact list
    });
  }

  /// Adds a new contact to the list and saves it to Hive
  void _addNewContact(ContactModel newContact) {
    // Checks for duplicate contacts based on name and phone number
    bool isDuplicate = contactList.any((contact) =>
        contact.name.toLowerCase() == newContact.name.toLowerCase() &&
        contact.phoneNumber == newContact.phoneNumber);

    if (isDuplicate) {
      // Shows feedback if the contact already exists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact already exists.')),
      );
      return;
    }

    setState(() {
      contactList.add(newContact); // Adds the contact to the UI optimistically
      isSaving = true; // Indicates a save operation is in progress
    });

    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false; // Save successful
        });
      } else {
        // Reverts changes if save fails
        setState(() {
          contactList.remove(newContact);
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save contact.')),
        );
      }
    });
  }

  /// Deletes a contact from the list and Hive storage
  void _deleteContact(ContactModel contactToDelete) {
    setState(() {
      contactList.remove(contactToDelete); // Removes the contact from the UI
    });

    HiveService.deleteContact(widget.user!, contactToDelete).then((success) {
      if (!success) {
        // Reverts changes if delete fails
        setState(() {
          contactList.add(contactToDelete);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete contact.')),
        );
      }
    });
  }
}
