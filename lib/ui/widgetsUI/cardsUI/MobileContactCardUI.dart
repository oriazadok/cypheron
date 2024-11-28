import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/LeadingUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

/// A reusable widget to display a contact card with custom styling.
class MobilecontactcardUI extends StatelessWidget {
  final String displayName;
  final String phoneNumber;
  final Function(Contact) onTap;

  const MobilecontactcardUI({
    required this.displayName,
    required this.phoneNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

      child: Card(
        color: Color(0xFF3A3A3C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        child: ListTile(
          leading: LeadingUI(type: IconType.person),
          title: Text(
            displayName,
            style: GenericTextStyleUI.getTextStyle(TextType.contact_card),
          ),
          subtitle: Text(
            phoneNumber,
            style: GenericTextStyleUI.getTextStyle(TextType.sub_title_contact_card),
          ),
          onTap: () {
            // Convert contact data to a `Contact` object and call `onTap`
            Contact selectedContact = Contact(
              displayName: displayName,
              phones: [Item(label: 'mobile', value: phoneNumber)],
            );
            onTap(selectedContact);
          },
        ),
      ),
    );
  }
}
