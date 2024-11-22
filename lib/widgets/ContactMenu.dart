import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cypheron/screens/creation/NewContact.dart';
import 'package:cypheron/screens/creation/MobileContacts.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/widgets/MenuOption.dart';

/// A reusable widget that displays the contact menu options.
class ContactMenu extends StatelessWidget {
  final Function(ContactModel) onAddContact;

  const ContactMenu({Key? key, required this.onAddContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MenuOption(
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
        MenuOption(
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
    );
  }
}
