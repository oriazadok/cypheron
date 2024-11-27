import 'package:flutter/material.dart';

import 'package:cypheron/models/ContactModel.dart';

import 'package:cypheron/ui/widgetsUI/utilsUI/EmptyStateUI.dart';  // Button widget for adding contacts
import 'package:cypheron/ui/widgetsUI/cardsUI/ContactCardUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/LeadingUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/OpsRowUI.dart';

import 'package:cypheron/screens/Contact_info/ContactInfo.dart';


/// A widget that displays a list of contacts with a clean UI.
class ContactList extends StatefulWidget {
  final List<ContactModel> contactList; // List of contacts to display
  final Function(ContactModel) onDelete; // Callback to delete a contact
  final Function() onLongPress; // Callback to update long-press state externally

  const ContactList({
    Key? key,
    required this.contactList,
    required this.onDelete,
    required this.onLongPress,
  }) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {

  ContactModel? selectedContact;

  @override
  Widget build(BuildContext context) {

    if (widget.contactList.isEmpty) 
      return EmptyStateUI(icon: IconsUI(type: IconType.contacts_outlined), message: 'No contacts found.\nAdd a new contact.');

    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.contactList.length,
          itemBuilder: (context, index) {
            final contact = widget.contactList[index];

            return ContactCardUI(
              leading: LeadingUI(type: IconType.person),
              title: contact.name,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactInfo(contact: contact),
                  ),
                );
              },
              onLongPress: () {
                if(selectedContact == null) {
                  setState(() {
                    selectedContact = contact; // Set the selected contact
                    widget.onLongPress();
                  });
                }
              },
            );
          },
        ),

        // Row of options displayed when a contact is selected
        if (selectedContact != null)
          OpsRowUI(
            options: [
              IconsUI(
                type: IconType.delete,
                onPressed: () {
                  widget.onDelete(selectedContact!); // Trigger delete action
                  setState(() {
                    selectedContact = null; // Reset selection
                    widget.onLongPress();
                  });
                },
              ),
              
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    selectedContact = null; // Reset selection
                  });
                  widget.onLongPress();
                },
              ),
            ],
          ),
      ],
    );
  }
}
