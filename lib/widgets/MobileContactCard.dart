import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

/// A reusable widget to display a contact card with custom styling.
class Mobilecontactcard extends StatelessWidget {
  final String displayName;
  final String phoneNumber;
  final Function(Contact) onTap;

  const Mobilecontactcard({
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
          leading: CircleAvatar(
            backgroundColor: Colors.deepPurpleAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            displayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            phoneNumber,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
            ),
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
