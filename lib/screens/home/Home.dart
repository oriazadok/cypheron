import 'package:flutter/material.dart';

import 'package:cypheron/models/UserModel.dart'; // Model for representing user data.
import 'package:cypheron/models/ContactModel.dart'; // Model for representing contact data.
import 'package:cypheron/services/HiveService.dart'; // Service for managing local data storage.

import 'package:cypheron/ui/screensUI/HomeUI.dart'; // Custom UI for the Home screen.
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart'; // Utility for creating icons and icon buttons.

import 'package:cypheron/widgets/lists/ContactsList.dart'; // Widget for displaying a list of contacts.
import 'package:cypheron/widgets/buttons/AddContactsButton.dart'; // Floating action button for adding contacts.

import 'package:cypheron/screens/auth/SignIn.dart'; // Sign-in screen for navigation after logout.

/// Home screen of the Cypheron app.
/// Displays a list of the user's contacts and handles operations like adding or deleting contacts.
/// Allows logging out and transitioning to the sign-in screen.
class Home extends StatefulWidget {
  /// Represents the currently logged-in user. Can be null for guest users.
  final UserModel? user;

  /// Constructor for the Home screen, requiring a [user].
  Home({required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// Stores the user's contacts.
  List<ContactModel> contactList = [];

  /// Tracks if a saving operation is in progress.
  bool isSaving = false;

  /// Tracks if a long press has occurred on a contact.
  bool isOnLongPress = false;

  @override
  void initState() {
    super.initState();

    // Load contacts if the user is provided.
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Attach the custom logic
      child: Scaffold(
        // AppBar with title and logout button.
        appBar: AppBar(
          title: Text("Cypheron"), // Display app title.
          actions: [
            IconsUI(
              type: IconType.logout, // Logout icon.
              onPressed: () {
                // Navigate to the SignIn screen and replace the current route.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
            ),
          ],
        ),

        // Body contains the main content of the Home screen.
        body: HomeUI(
          isSaving: isSaving, // Pass saving state to UI for displaying a loading indicator.
          contactList: ContactList(
            contactList: contactList, // Pass the contact list to display.
            onDelete: (ContactModel contact) {
              _deleteContact(contact); // Handle contact deletion.
            },
            onLongPress: () {
              setState(() {
                isOnLongPress = !isOnLongPress; // Toggle the long press state.
              });
            },
          ),
        ),

        // Floating action button for adding contacts, visible only when not in long press mode.
        floatingActionButton: !isOnLongPress
            ? AddContactButton(onAddContact: _addNewContact)
            : null,
      )
    );
  }


  // This will handle the back button behavior
  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to leave the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Stay on screen
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Leave screen
            child: Text('Yes'),
          ),
        ],
      ),
    );
    return shouldPop ?? false; // Return true to exit, false to stay
  }

  /// Loads contacts from Hive by their IDs.
  /// Updates the contact list in the state.
  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts;
    });
  }

  /// Adds a new contact to the list and saves it to Hive.
  /// Shows a loading indicator during the save operation.
  void _addNewContact(ContactModel newContact) {
    // Check for duplicate contacts.
    bool isDuplicate = contactList.any((contact) =>
        contact.name.toLowerCase() == newContact.name.toLowerCase() &&
        contact.phoneNumber == newContact.phoneNumber);

    if (isDuplicate) {
      // Show feedback if contact already exists.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact already exists.')),
      );
      return;
    }

    setState(() {
      contactList.add(newContact); // Add contact optimistically to the UI.
      isSaving = true; // Show loading indicator.
    });

    // Save contact to Hive.
    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false; // Hide loading indicator on success.
        });
      } else {
        setState(() {
          contactList.remove(newContact); // Revert changes on failure.
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save contact.')),
        );
      }
    });
  }

  /// Deletes a contact from the list and Hive.
  void _deleteContact(ContactModel contactToDelete) {
    setState(() {
      contactList.remove(contactToDelete); // Remove contact from the UI.
    });

    HiveService.deleteContact(widget.user!, contactToDelete).then((success) {
      if (!success) {
        setState(() {
          contactList.add(contactToDelete); // Revert changes on failure.
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete contact.')),
        );
      }
    });
  }
}
