import 'package:flutter/material.dart';

import 'package:cypheron/models/UserModel.dart';  // Model representing user data.
import 'package:cypheron/models/ContactModel.dart';  // Model representing contact data.
import 'package:cypheron/services/HiveService.dart';  // Service for managing local data storage.

import 'package:cypheron/ui/screensUI/HomeUI.dart';  // UI-specific customizations for the Home screen.
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';  // Utility for building icons and icon buttons.

import 'package:cypheron/widgets/cards/ContactsList.dart';  // Widget for displaying a list of contacts.
import 'package:cypheron/widgets/buttons/addContactsButton.dart';  // Floating action button for adding contacts.

/// The Home screen of the Cypheron app.
/// Displays a list of user's contacts and provides functionality to manage them.
/// Also handles actions like adding new contacts or logging out.
class Home extends StatefulWidget {
  /// The currently logged-in user. Optional to allow guest users.
  final UserModel? user;

  /// Constructor for the Home widget.
  /// Accepts an optional [user] to manage their data.
  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /// List to store the user's contacts.
  List<ContactModel> contactList = [];

  /// Boolean to indicate whether a saving operation is in progress.
  bool isSaving = false;
  bool onLongPress = false;

  @override
  void initState() {
    super.initState();

    // Load the user's contacts from the database if the user is provided.
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a title and a logout button.
      appBar: AppBar(
        title: Text("Cypheron"), // App title.
        // centerTitle: true,
        actions: [
          IconsUI(
            context: context,
            type: IconType.logout,
            isButton: true, // Logout button.
          )
        ],
      ),

      // Body of the screen displaying the contacts list.
      body: HomeUI(
        isSaving: isSaving, // Passes the saving state to the UI.
        contactList: ContactList(
          contactList: contactList,
          onDelete: (ContactModel contact) {
            _deleteContact(contact);
          },
          onLongPress: () {
            setState(() {
              onLongPress = ! onLongPress;
            });
          },
        ), // Displays the contact list.
      ),

      // Floating action button to add a new contact.
      floatingActionButton: ! onLongPress
          ? AddContactButton( onAddContact: _addNewContact )
          : null,
    );
  }

  /// Loads contacts from the Hive database using their IDs.
  /// Updates the UI with the loaded contacts.
  void _loadContactsByIds(List<String> contactIds) async {
    // Load contacts from Hive based on provided IDs.
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts; // Update the contact list in the state.
    });
  }

  /// Adds a new contact to the list and saves it to the Hive database.
  /// Displays a loading indicator while saving.
  void _addNewContact(ContactModel newContact) {

    // Check if the contact already exists in the contact list
    bool isDuplicate = contactList.any((contact) =>
        contact.name.toLowerCase() == newContact.name.toLowerCase() &&
        contact.phoneNumber == newContact.phoneNumber);

    if (isDuplicate) {
      // Show feedback to the user if the contact already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact already exists.')),
      );
      return; // Exit the function without adding the contact
    }
    
    setState(() {
      contactList.add(newContact); // Optimistically update the UI.
      isSaving = true; // Show loading indicator.
    });

    // Save the contact to Hive and update the user's contact list.
    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false; // Hide loading indicator on success.
        });
      } else {
        // If saving fails, revert UI changes and show an error message.
        setState(() {
          contactList.remove(newContact); // Remove the contact from the list.
          isSaving = false; // Hide loading indicator.
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save contact.')), // Show error feedback.
        );
      }
    });
  }

  void _deleteContact(ContactModel contactToDelete) {
    setState(() {
      contactList.remove(contactToDelete); // Remove contact from UI
    });

    HiveService.deleteContact(widget.user!, contactToDelete).then((success) {
      if (!success) {
        setState(() {
          contactList.add(contactToDelete); // Re-add contact if deletion fails
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete contact.')),
        );
      }
    });
  }
}
