import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'ContactDetail.dart';  // Import the new ContactDetail screen

class ContactList extends StatelessWidget {
  final List<Contact> contactList;  // List of selected contacts

  ContactList({required this.contactList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact List',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // Display only the name of selected contacts
          for (var contact in contactList)
            InkWell(
              onTap: () {
                // Navigate to the ContactDetail screen when a contact is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactDetail(
                      contactName: contact.displayName ?? 'No Name',
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${contact.displayName ?? 'No Name'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(),  // Add a divider between contacts
                ],
              ),
            ),
        ],
      ),
    );
  }
}
