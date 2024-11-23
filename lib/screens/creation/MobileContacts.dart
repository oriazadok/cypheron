import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cypheron/services/HiveService.dart';
import 'package:cypheron/ui/screensUI/MobileContactsUI.dart'; // Import the wrapper
import 'package:cypheron/ui/widgetsUI/FittedTextUI.dart';
import 'package:cypheron/ui/widgetsUI/AppBarUI.dart';
import 'package:cypheron/ui/widgetsUI/IconsUI.dart';


import 'package:cypheron/ui/widgetsUI/cardsUI/MobileContactCardUI.dart'; // Import the new LoadingIndicator

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUI(
        title: 'Mobile Contacts',
        actions: [
          IconsUI(context: context, type: "refresh", isButton: true, onPressed: refreshContacts), 
        ],
      ),
      body: MobileContactsUI(
        isFetching: isFetching,
        contacts: contacts,
        refresh: RefreshIndicator(
                  onRefresh: refreshContacts,
                  child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contactData = contacts[index];
                      String displayName = contactData['displayName'];
                      String phoneNumber = contactData['phoneNumber'];

                      return MobilecontactcardUI(
                        displayName: displayName,
                        phoneNumber: phoneNumber,
                        onTap: (Contact selectedContact) {
                          Navigator.pop(context, selectedContact);
                        },
                      );
                    },
                  ),
                ),
        error: FittedTextUI(text: 'No contacts found. Swipe down to refresh.', type: "err"),
      ),
    );
    
    
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

}
