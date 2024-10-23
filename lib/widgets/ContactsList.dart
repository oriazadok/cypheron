import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';

class ContactList extends StatefulWidget {
  final List<ContactModel> contactList;

  ContactList({required this.contactList});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<ContactModel>? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.contactList.length,
      itemBuilder: (context, index) {
        final contact = widget.contactList[index];
        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
          onTap: () {
            setState(() {
              // _selectedContact = contact;  // Handle click event and store selected contact
            });
            _showContactDetails(context, contact);  // Show details or open new screen
          },
        );
      },
    );
  }

  // Display the selected contact's details in a dialog or navigate to another screen
  void _showContactDetails(BuildContext context, ContactModel contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(contact.name),
          content: Text('Phone: ${contact.phoneNumber}'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
