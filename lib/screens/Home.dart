import 'package:flutter/material.dart';
import 'package:cypheron/models/UserModel.dart';  // The UserModel
import 'package:cypheron/services/HiveService.dart';
import 'auth/SignIn.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/widgets/ContactsList.dart';  
import 'package:cypheron/widgets/buttons/addContactsButton.dart'; 

class Home extends StatefulWidget {
  final UserModel user;  // Accept the complete UserModel object

  Home({required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ContactModel> contactList = [];
  bool isSaving = false;  // To show a loading indicator during save process

  @override
  void initState() {
    super.initState();
    _loadContactsByIds(widget.user.contactIds);  // Load contacts by contactIds
  }

  // Load contacts from Hive using contactIds
  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts;
    });
  }

  // Add new contact and initiate async save
  void _addNewContact(ContactModel newContact) {
    setState(() {
      contactList.add(newContact);  // Instant UI update
      isSaving = true;  // Start loading indicator
    });

    // Save contact and update user contact list asynchronously
    HiveService.saveContact(widget.user, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false;  // Stop showing the loading indicator
        });
      } else {
        // Handle failure (e.g., remove contact from UI)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Welcome, ${widget.user.name}!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (isSaving)  // Show a loading indicator when saving
            LinearProgressIndicator(),
          if (contactList.isNotEmpty) 
            Expanded(
              child: ContactList(contactList: contactList),
            ),
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
      floatingActionButton: buildFloatingActionButton(context, widget.user.userId, _addNewContact),
    );
  }
}
