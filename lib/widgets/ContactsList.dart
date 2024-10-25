import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/screens/ContactInfo.dart';  // Import the new ContactInfo screen

class ContactList extends StatelessWidget {
  final List<ContactModel> contactList;

  ContactList({required this.contactList});

  @override
  Widget build(BuildContext context) {
    if (contactList.isEmpty) {
      return Center(
        child: Text('No contacts found. Add or view contacts.'),
      );
    }

    return ListView.builder(
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        final contact = contactList[index];
        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
          onTap: () {
            // Navigate to ContactInfo screen with the selected contact's details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactInfo(contact: contact),
              ),
            );
          },
        );
      },
    );
  }
}
