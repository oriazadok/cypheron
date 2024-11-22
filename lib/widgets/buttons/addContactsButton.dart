import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/widgets/dialogs/CustomDialog.dart';
import 'package:cypheron/widgets/ContactMenu.dart';

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
        content: ContactMenu(onAddContact: onAddContact),
        actions: [],
      );
    },
    child: Icon(Icons.add, color: Colors.white, size: 28),
    tooltip: 'Add Contact',
  );
}
