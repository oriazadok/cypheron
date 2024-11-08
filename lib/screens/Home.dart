import 'package:flutter/material.dart';
import 'package:cypheron/models/UserModel.dart';  // Model for user data
import 'auth/SignIn.dart';  // Screen to navigate for signing in
import 'package:cypheron/services/HiveService.dart';  // Service to manage local data storage
import 'package:cypheron/models/ContactModel.dart';  // Model for contacts
import 'package:cypheron/widgets/ContactsList.dart';  // Widget to display contact list
import 'package:cypheron/widgets/buttons/addContactsButton.dart';  // Button widget for adding contacts

/// Home screen that displays user's contacts and enables decryption of shared files.
class Home extends StatefulWidget {
  final UserModel? user;          // Optional UserModel, representing the current user

  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ContactModel> contactList = [];  // List to store user's contacts
  bool isSaving = false;                // Loading indicator for saving process
  

  @override
  void initState() {
    super.initState();

    // Load contacts if a user is provided
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // Logout button to navigate to SignIn screen
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display welcome message if user is signed in
          if (widget.user != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Welcome, ${widget.user?.name ?? ''}!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (isSaving)  // Show loading indicator when saving
            LinearProgressIndicator(),
          // Display list of contacts if available
          if (contactList.isNotEmpty) 
            Expanded(
              child: ContactList(contactList: contactList),
            ),
          // Message prompting user to add contacts if list is empty
          if (contactList.isEmpty && !isSaving)
            Expanded(
              child: Center(
                child: Text(
                  'Add or View Contacts',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
      // Show floating action button to add new contacts if user is signed in
      floatingActionButton: widget.user != null
          ? buildFloatingActionButton(context, widget.user!.userId, _addNewContact)
          : null,
    );
  }

  /// Loads contacts from Hive database using provided contact IDs.
  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts;
    });
  }

  /// Adds a new contact and saves it asynchronously to Hive.
  void _addNewContact(ContactModel newContact) {
    setState(() {
      contactList.add(newContact);  // Update UI instantly
      isSaving = true;  // Start showing loading indicator
    });

    // Save contact to database and update user's contact list
    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false;  // Stop showing loading indicator on success
        });
      } else {
        // If saving fails, revert UI and show error message
        setState(() {
          contactList.remove(newContact);  // Revert UI changes
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save contact.')),
        );
      }
    });
  }
}
