import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cypheron/services/HiveService.dart';

class MobileContacts extends StatefulWidget {
  @override
  _MobileContactsState createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  List<Map<String, dynamic>> contacts = [];
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    loadContactsFromHive();
  }

  /// Load contacts from Hive
  void loadContactsFromHive() {
    setState(() {
      contacts = HiveService.getCachedContacts();
    });
  }

  /// Refresh contacts manually
  Future<void> refreshContacts() async {
    setState(() {
      isFetching = true;
    });
    await HiveService.clearCachedContacts();
    await HiveService.loadContactsIfNeeded();
    loadContactsFromHive();
    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isFetching ? null : refreshContacts,
          ),
        ],
      ),
      body: isFetching
          ? Center(child: CircularProgressIndicator())
          : contacts.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: refreshContacts,
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contactData = contacts[index];
                      String displayName = contactData['displayName'];
                      String phoneNumber = contactData['phoneNumber'];

                      return ListTile(
                        title: Text(displayName),
                        subtitle: Text(phoneNumber),
                        onTap: () {
                          // Convert simplified contact data back to a Contact object
                          Contact selectedContact = Contact(
                            displayName: displayName,
                            phones: [Item(label: 'mobile', value: phoneNumber)],
                          );
                          Navigator.pop(context, selectedContact);
                        },
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    'No contacts found. Swipe down to refresh.',
                    style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  ),
                ),
    );
  }
}
