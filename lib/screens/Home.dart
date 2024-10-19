import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'new_contact.dart';  // Screen for manually creating a new contact
import 'Mobile_contacts.dart';  // Screen to get contacts from the mobile device
import 'Sign_in.dart';  // Import SignIn screen for logout
import 'ContactList.dart';  // Import the new ContactList widget
import 'package:contacts_service/contacts_service.dart';  // Import the Contact class

class Home extends StatefulWidget {
  final String username;

  Home({required this.username});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Contact> contactList = [];  // List to store multiple selected contacts
  Box? contactBox;  // Hive box for storing contacts
  late Future<void> _loadContactsFuture;  // Cached future

  @override
  void initState() {
    super.initState();
    _loadContactsFuture = openHiveBox();  // Cache the future
  }

  // Open Hive box and load contacts
  Future<void> openHiveBox() async {
    contactBox = await Hive.openBox('contactsBox');
    print('Opened Hive box');
    loadContactsFromHive();  // Load contacts after opening the box
  }

  // Load contacts from Hive box (deserialize)
  void loadContactsFromHive() {
    try {
      final storedContacts = contactBox?.get('contactsList') ?? [];
      print('Contacts loaded from Hive: $storedContacts');

      // Cast each contact's map to Map<String, dynamic> before deserialization
      setState(() {
        contactList = storedContacts.map<Contact>((contactData) {
          return deserializeContact(Map<String, dynamic>.from(contactData));  // Explicit cast
        }).toList();
      });

      print('Deserialized Contact List: $contactList');
    } catch (error) {
      print('Error loading contacts from Hive: $error');
    }
  }

  // Save contacts to Hive box (serialize)
  void saveContactsToHive() {
    try {
      final serializedContacts = contactList.map((contact) => serializeContact(contact)).toList();
      contactBox?.put('contactsList', serializedContacts);
      print('Contacts saved to Hive: $serializedContacts');
    } catch (error) {
      print('Error saving contacts to Hive: $error');
    }
  }

  // Serialize contact to a Map for storage in Hive
  Map<String, dynamic> serializeContact(Contact contact) {
    return {
      'displayName': contact.displayName,
      'phones': contact.phones?.map((item) => item.value).toList(),
    };
  }

  // Deserialize contact from a Map retrieved from Hive
  Contact deserializeContact(Map<String, dynamic> contactData) {
    return Contact(
      displayName: contactData['displayName'],
      phones: contactData['phones'] != null
          ? contactData['phones'].map<Item>((phone) => Item(value: phone)).toList()
          : [],
    );
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
              // Sign out and navigate back to the sign-in screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadContactsFuture,  // Use the cached future
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show loading spinner while waiting
          } else if (snapshot.hasError) {
            // Log the error and show it in the UI
            print('Error in FutureBuilder: ${snapshot.error}');
            return Center(child: Text('Error loading contacts: ${snapshot.error}'));
          } else {
            return Column(
              children: [
                // Center the welcome message at the top
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'Welcome, ${widget.username}!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                // Use the ContactList widget to display the selected contacts
                if (contactList.isNotEmpty)
                  ContactList(contactList: contactList),
                // Show "Add or View Contacts" only if no contacts are selected
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
      // Add a floating action button (+) at the bottom right corner
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to choose between adding a new contact or selecting one from mobile contacts
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Choose an action'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.person_add),
                      title: Text('Create New Contact'),
                      onTap: () {
                        // Navigate to manually create a new contact
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewContact()),
                        );
                        Navigator.pop(context);  // Close the dialog
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.contacts),
                      title: Text('Get Contacts from Mobile'),
                      onTap: () async {
                        // Navigate to MobileContacts screen and wait for the selected contact
                        final Contact? contact = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MobileContacts()),
                        );
                        if (contact != null) {
                          // Add the selected contact to the contact list
                          setState(() {
                            contactList.add(contact);  // Add the new contact to the list
                          });
                          saveContactsToHive();  // Save the updated contact list to Hive
                        }
                        Navigator.pop(context);  // Close the dialog
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),  // The plus icon
        tooltip: 'Add Contact',
      ),
    );
  }
}