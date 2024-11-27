import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/ui/widgetsUI/dialogsUI/ContactsDialogUI.dart';
import 'package:cypheron/widgets/dialogs/ContactMenu.dart';
import 'package:cypheron/ui/widgetsUI/buttonUI/FloatButtonUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';


/// A floating action button for adding a new contact.
class AddContactButton extends StatelessWidget {
  /// Callback function to handle adding the new contact.
  final Function(ContactModel) onAddContact;

  /// Constructor with a required callback to handle the new contact.
  const AddContactButton({required this.onAddContact});

  @override
  Widget build(BuildContext context) {
    return FloatButtonUI(
      onPressed: () {
        ContactsDialogUI.show(
          context: context,
          title: "Choose an Action",
          content: ContactMenu(onAddContact: onAddContact), // Dynamically pass the menu content
          actions: [],
        );
      },
      icon: IconsUI(type: IconType.person_add_alt_1_outlined),
      tooltip: 'Add Contact',
    );
  }
}
