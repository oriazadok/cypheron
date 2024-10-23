import 'package:flutter/material.dart';

import 'package:cypheron/models/UserModel.dart';  // The UserModel

import 'package:cypheron/services/HiveService.dart';
import 'auth/SignIn.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/widgets/ContactsList.dart';  // Import the floating action button module
import 'package:cypheron/widgets/buttons/addContactsButton.dart';  // Import the floating action button module

/*
  ToDo:
  after creting a new contact also save in hive
  likewise for creating manual
*/

class Home extends StatefulWidget {
  final UserModel user;  // Accept the complete UserModel object

  Home({required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ContactModel> contactList = [];
  late Future<void> _loadContactsFuture;

  @override
  void initState() {
    super.initState();
    _loadContactsFuture = _loadContactsByIds(widget.user.contactIds);  // Load contacts by contactIds
  }

  // Load the contacts from Hive using the contact IDs
  Future<void> _loadContactsByIds(List<String> contactIds) async {
    // List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    // setState(() {
    //   contactList = loadedContacts;  // Update the contact list with loaded data
    // });
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
      body: FutureBuilder(
        future: _loadContactsFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading contacts: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Welcome, ${widget.user.name}!',  // Display the user's name
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                if (contactList.isNotEmpty) 
                  Expanded(
                    child: ContactList(contactList: contactList),
                  ),
                if (contactList.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Add or View Contacts',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
      floatingActionButton: buildFloatingActionButton(context, widget.user.userId, _addNewContact),
    );
  }

  // Function to add a new contact
  void _addNewContact(ContactModel newContact) {
    setState(() {
      contactList.add(newContact);
    });
  }
}
