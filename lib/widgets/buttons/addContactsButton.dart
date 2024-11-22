import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/widgets/dialogs/CustomDialog.dart';
import 'package:cypheron/widgets/ContactMenu.dart';

/// A floating action button for adding a new contact.
class AddContactButton extends StatelessWidget {
  /// Callback function to handle adding the new contact.
  final Function(ContactModel) onAddContact;

  /// Constructor with a required callback to handle the new contact.
  const AddContactButton({required this.onAddContact});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 8,
      onPressed: () {
        CustomDialog.showCustomDialog(
          context: context,
          title: "Choose an Action",
          content: ContactMenu(onAddContact: onAddContact), // Dynamically pass the menu content
          actions: [],
        );
      },
      child: Icon(Icons.add, color: Colors.white, size: 28),
      tooltip: 'Add Contact',
    );
  }
}
