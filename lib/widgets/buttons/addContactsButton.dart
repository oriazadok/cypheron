import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
// import 'package:cypheron/screens/NewContact.dart';
import 'package:cypheron/screens/MobileContacts.dart';
import 'package:cypheron/models/ContactModel.dart';

FloatingActionButton buildFloatingActionButton(
    BuildContext context, String userId, Function(ContactModel) onAddContact) {
  return FloatingActionButton(
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose an action'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ListTile(
                //   leading: Icon(Icons.person_add),
                //   title: Text('Create New Contact'),
                //   onTap: () {
                //     // When the user taps "Create New Contact"
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => NewContact(
                //         onSave: (newContact) {
                //           newContact.userId = userId;  // Assign the userId to the new contact
                //           onAddContact(newContact);  // Pass the new contact back to Home screen
                //         }
                //       )),
                //     );
                //     Navigator.pop(context);  // Close the dialog after navigating
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.contacts),
                  title: Text('Get Contacts from Mobile'),
                  onTap: () async {
                    final Contact? contact = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MobileContacts()),
                    );
                    if (contact != null) {
                      String contactName = contact.displayName ?? 'No Name';
                      String contactPhone = (contact.phones != null && contact.phones!.isNotEmpty)
                          ? contact.phones!.first.value ?? 'No Phone'
                          : 'No Phone';

                      ContactModel newContact = ContactModel(
                        name: contactName,
                        phoneNumber: contactPhone,
                      );

                      onAddContact(newContact);  // Call the callback to add the new contact to the list
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
    child: Icon(Icons.add),
    tooltip: 'Add Contact',
  );
}
