import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/ui/widgetsUI/dialogsUI/ContactsDialogUI.dart';
import 'package:cypheron/widgets/dialogs/ContactMenu.dart';
import 'package:cypheron/ui/widgetsUI/buttonUI/FloatBtnUI.dart';

/// A floating action button for adding a new contact.
class AddContactButton extends StatelessWidget {
  /// Callback function to handle adding the new contact.
  final Function(ContactModel) onAddContact;

  /// Constructor with a required callback to handle the new contact.
  const AddContactButton({required this.onAddContact});

  @override
  Widget build(BuildContext context) {
    return FloatBtnUI(
            onPressed: () {
              ContactsDialogUI.show(
                context: context,
                title: "Choose an Action",
                content: ContactMenu(onAddContact: onAddContact), // Dynamically pass the menu content
                actions: [],
              );
            },
            tooltip: 'Add Contact',
    );
  }
}
