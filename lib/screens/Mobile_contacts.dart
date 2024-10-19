import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileContacts extends StatefulWidget {
  @override
  _MobileContactsState createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  void getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      try {
        Iterable<Contact> mobileContacts = await ContactsService.getContacts();
        setState(() {
          contacts = mobileContacts.toList();
        });
      } catch (e) {
        print("Error fetching contacts: $e");
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access contacts denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Contacts'),
      ),
      body: contacts.isNotEmpty
          ? ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                String displayName = contact.displayName ?? 'No Name';
                String phoneNumber = (contact.phones?.isNotEmpty ?? false)
                    ? contact.phones!.first.value ?? 'No Phone Number'
                    : 'No Phone Number';

                return ListTile(
                  title: Text(displayName),
                  subtitle: Text(phoneNumber),
                  onTap: () {
                    // Pass the selected contact back to the Home page
                    Navigator.pop(context, contact);
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
