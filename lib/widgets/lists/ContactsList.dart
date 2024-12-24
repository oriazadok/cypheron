import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/ui/widgetsUI/cardsUI/ContactCardUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/LeadingUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/EmptyStateUI.dart';


class ContactList extends StatelessWidget {
  final List<ContactModel> contactList; // List of contacts to display
  final Function(ContactModel) onTap; // Callback for deleting a contact
  final Function(ContactModel) onLongPress; // Callback for long-press behavior
  final ContactModel? selectedContact; // The currently selected contact

  const ContactList({
    Key? key,
    required this.contactList,
    required this.onTap,
    required this.onLongPress,
    this.selectedContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contactList.isEmpty) {
      return EmptyStateUI(
        icon: IconsUI(type: IconType.contacts_outlined),
        message: 'No contacts found.\nAdd a new contact.',
      );
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: contactList.length,
          itemBuilder: (context, index) {
            final contact = contactList[index];
            final isSelected = selectedContact == contact;
            return GestureDetector(
          
              child: Container(
                decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    )
                  : null, // No additional UI features for non-selected contacts
                      
                child: ContactCardUI(
                  leading: LeadingUI(type: IconType.person),
                  title: contact.name,
                  onTap: () {
                    if (selectedContact == null) {
                      onTap(contact);
                    }
                  },
                  onLongPress: () {
                    onLongPress(contact); // Trigger long-press callback
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
