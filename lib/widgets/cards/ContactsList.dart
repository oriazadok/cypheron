import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/screens/Contact_info/ContactInfo.dart';
import 'package:cypheron/ui/widgetsUI/cardsUI/ContactCardUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/EmptyStateUI.dart';  // Button widget for adding contacts
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/LeadingUI.dart';


/// A widget that displays a list of contacts with a clean UI.
class ContactList extends StatefulWidget {
  final List<ContactModel> contactList; // List of contacts to display
  final Function(ContactModel) onDelete; // Callback to delete a contact

  const ContactList({
    Key? key,
    required this.contactList,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {

  ContactModel? selectedContact;

  @override
  Widget build(BuildContext context) {

    if (widget.contactList.isEmpty) 
      return EmptyStateUI(icon: IconsUI(type: "contacts_outlined"), message: 'No contacts found.\nAdd a new contact.');

    return Stack(
      children: [
        ListView.builder(
          itemCount: widget.contactList.length,
          itemBuilder: (context, index) {
            final contact = widget.contactList[index];

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
              onLongPress: () {
                setState(() {
                  selectedContact = contact; // Set the selected contact
                });
              },
            );
          },
        ),

        // Row of options displayed when a contact is selected
        if (selectedContact != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Delete button
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      widget.onDelete(selectedContact!); // Trigger delete callback
                      setState(() {
                        selectedContact = null; // Reset selection
                      });
                    },
                  ),
                  // Cancel button to close the options row
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        selectedContact = null; // Reset selection
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
    
    
    
  }
}
