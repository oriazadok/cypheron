import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/screens/ContactInfo.dart';  // Import the ContactInfo screen to display contact details

/// A widget that displays a list of contacts.
class ContactList extends StatelessWidget {
  /// The list of contacts to display.
  final List<ContactModel> contactList;

  /// Constructor for ContactList, with a required list of contacts.
  ContactList({required this.contactList});

  @override
  Widget build(BuildContext context) {
    // If the contact list is empty, display a placeholder message.
    if (contactList.isEmpty) {
      return Center(
        child: Text('No contacts found. Add or view contacts.'),
      );
    }

    // Otherwise, build a ListView to display each contact.
    return ListView.builder(
      itemCount: contactList.length,  // Set the number of items in the list
      itemBuilder: (context, index) {
        // Get the current contact from the list
        final contact = contactList[index];

        // Build a ListTile for each contact
        return ListTile(
          title: Text(contact.name),  // Display the contact's name
          subtitle: Text(contact.phoneNumber),  // Display the contact's phone number
          onTap: () {
            // When a contact is tapped, navigate to the ContactInfo screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactInfo(contact: contact),  // Pass the selected contact to ContactInfo
              ),
            );
          },
        );
      },
    );
  }
}
