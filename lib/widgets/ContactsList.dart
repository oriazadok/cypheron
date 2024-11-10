import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/screens/ContactInfo.dart';
import 'package:cypheron/ui/Contact_card_style.dart';

/// A widget that displays a list of contacts with a clean UI.
class ContactList extends StatelessWidget {
  /// The list of contacts to display.
  final List<ContactModel> contactList;

  /// Constructor for ContactList, with a required list of contacts.
  ContactList({required this.contactList});

  @override
  Widget build(BuildContext context) {

    if (contactList.isEmpty)
      return  Center(
          child: Text(
            'No contacts found. Please add contacts.',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        );

    return  ListView.builder(
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        final contact = contactList[index];

        return ContactCardStyle.buildContactCard(
          context: context,
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          title: contact.name,
          onTap: () {
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
