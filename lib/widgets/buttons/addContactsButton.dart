import 'package:cypheron/screens/NewContact.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cypheron/screens/MobileContacts.dart';
import 'package:cypheron/models/ContactModel.dart';

/// Builds a floating action button that provides options for adding contacts.
FloatingActionButton buildFloatingActionButton(
    BuildContext context, String userId, Function(ContactModel) onAddContact) {
  return FloatingActionButton(
    // Action triggered when the button is pressed
    onPressed: () {
      // Show a dialog with contact-adding options
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // Title of the dialog
            title: Text('Choose an action'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Option to create a new contact manually
                ListTile(
                  leading: Icon(Icons.person_add),  // Icon for new contact
                  title: Text('Create New Contact'),
                  onTap: () async {
                    // Navigate to NewContact screen to create a contact
                    final ContactModel? newContact = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewContact()),
                    );
                    // If a new contact was created, add it to the list
                    if (newContact != null) {
                      onAddContact(newContact);  // Add contact using callback
                    }
                    Navigator.pop(context);  // Close the dialog
                  },
                ),
                // Option to import a contact from the device
                ListTile(
                  leading: Icon(Icons.contacts),  // Icon for mobile contacts
                  title: Text('Get Contacts from Mobile'),
                  onTap: () async {
                    // Navigate to MobileContacts screen to select a contact
                    final Contact? contact = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MobileContacts()),
                    );
                    // If a contact was selected, extract details and add it
                    if (contact != null) {
                      String contactName = contact.displayName ?? 'No Name';
                      String contactPhone = (contact.phones != null && contact.phones!.isNotEmpty)
                          ? contact.phones!.first.value ?? 'No Phone'
                          : 'No Phone';

                      // Create a new ContactModel with selected contact details
                      ContactModel newContact = ContactModel(
                        name: contactName,
                        phoneNumber: contactPhone,
                      );

                      onAddContact(newContact);  // Add contact using callback
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
    child: Icon(Icons.add),  // Icon on the button
    tooltip: 'Add Contact',  // Tooltip displayed on long press
  );
}
