import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/screens/Contact_info/ContactInfo.dart';
import 'package:cypheron/ui/widgetsUI/ContactCardUI.dart';
import 'package:cypheron/ui/widgetsUI/EmptyStateUI.dart';  // Button widget for adding contacts
import 'package:cypheron/ui/widgetsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/LeadingUI.dart';


/// A widget that displays a list of contacts with a clean UI.
class ContactList extends StatelessWidget {
  /// The list of contacts to display.
  final List<ContactModel> contactList;

  /// Constructor for ContactList, with a required list of contacts.
  ContactList({required this.contactList});

  @override
  Widget build(BuildContext context) {

    if (contactList.isEmpty) 
      return EmptyStateUI(icon: IconsUI(type: "contacts_outlined"), message: 'No contacts found.\nAdd a new contact.');

    return  ListView.builder(
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        final contact = contactList[index];

        return ContactCardUI(
          leading: LeadingUI(type: "person"),
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
