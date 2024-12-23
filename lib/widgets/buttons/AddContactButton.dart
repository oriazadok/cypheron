import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/widgets/menu/ContactMenu.dart';
import 'package:cypheron/ui/widgetsUI/buttonUI/FloatButtonUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/dialogsUI/DialogUI.dart';


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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogUI(
              title: "Choose an Action",
              content: ContactMenu(onAddContact: onAddContact),
            );
          },
        );
      },
      icon: IconsUI(type: IconType.person_add_alt_1_outlined),
      tooltip: 'Add Contact',
    );
  }
}
