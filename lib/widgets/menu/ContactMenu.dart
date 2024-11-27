import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cypheron/screens/creation/NewContact.dart';
import 'package:cypheron/screens/creation/MobileContacts.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/ui/menuUI/MenuOptionUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/menuUI/ContactMenuUI.dart';


/// A reusable widget that displays the contact menu options.
class ContactMenu extends StatelessWidget {
  final Function(ContactModel) onAddContact;

  const ContactMenu({Key? key, required this.onAddContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContactMenuUI(
      options: [
        MenuOptionUI(
          icon: IconsUI(type: IconType.person_add),
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
        MenuOptionUI(
          icon: IconsUI(type: IconType.contacts),
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
