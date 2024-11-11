// lib/widgets/build_floating_action_button.dart
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cypheron/screens/NewContact.dart';
import 'package:cypheron/screens/MobileContacts.dart';
import 'package:cypheron/models/ContactModel.dart';

import 'package:cypheron/widgets/CustomDialog.dart';

/// Builds a floating action button with a dark-themed menu for adding contacts.
FloatingActionButton buildFloatingActionButton(
    BuildContext context, String userId, Function(ContactModel) onAddContact) {
  return FloatingActionButton(
    backgroundColor: Colors.deepPurpleAccent,
    elevation: 8,
    onPressed: () {
      CustomDialog.showCustomDialog(
        context: context,
        title: "Choose an Action",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuOption(
              context,
              icon: Icons.person_add_alt_1,
              text: 'Create New Contact',
              onTap: () async {
                Navigator.pop(context);
                final ContactModel? newContact = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewContact()),
                );
                if (newContact != null) {
                  onAddContact(newContact);
                }
              },
            ),
            SizedBox(height: 15),
            _buildMenuOption(
              context,
              icon: Icons.contacts,
              text: 'Import from Mobile',
              onTap: () async {
                Navigator.pop(context);
                final Contact? contact = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MobileContacts()),
                );
                if (contact != null) {
                  String contactName = contact.displayName ?? 'No Name';
                  String contactPhone = (contact.phones?.isNotEmpty ?? false)
                      ? contact.phones!.first.value ?? 'No Phone'
                      : 'No Phone';

                  ContactModel newContact = ContactModel(
                    name: contactName,
                    phoneNumber: contactPhone,
                  );

                  onAddContact(newContact);
                }
              },
            ),
          ],
        ),
        actions: [],
      );
    },
    child: Icon(Icons.add, color: Colors.white, size: 28),
    tooltip: 'Add Contact',
  );
}

/// Helper method to build a menu option with consistent styling.
Widget _buildMenuOption(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
  return ListTile(
    leading: Icon(icon, color: Colors.deepPurpleAccent, size: 28),
    title: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    tileColor: Color(0xFF2C2C34),
    onTap: onTap,
  );
}
