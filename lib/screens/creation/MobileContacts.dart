import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:cypheron/services/HiveService.dart';

import 'package:cypheron/ui/widgetsUI/app_barUI/AppBarUI.dart';
import 'package:cypheron/ui/screensUI/MobileContactsUI.dart';
import 'package:cypheron/ui/widgetsUI/cardsUI/MobileContactCardUI.dart'; 
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';


/// A screen that displays mobile contacts using a cached data source (Hive).
/// Users can refresh the contact list or navigate back after selecting a contact.
class MobileContacts extends StatefulWidget {
  @override
  _MobileContactsState createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  /// List of contacts fetched from the Hive cache.
  List<Map<String, dynamic>> contacts = [];
  
  /// Indicates whether the app is currently fetching contacts.
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    // Load cached contacts when the screen initializes.
    loadContactsFromHive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar with a title and refresh button.
      appBar: AppBarUI(
        title: 'Mobile Contacts',
        actions: [
          // Refresh button to manually reload contacts.
          IconsUI(type: IconType.refresh, onPressed: refreshContacts), 
        ],
      ),
      // Main body of the screen.
      body: MobileContactsUI(

        isFetching: isFetching,

        child: contacts.isNotEmpty
          ? RefreshIndicator(
            onRefresh: refreshContacts,
            child: ListView.builder(
              // Number of contacts to display.
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                // Extract contact data for the current index.
                final contactData = contacts[index];

                // Display each contact using a reusable UI card.
                return MobilecontactcardUI(
                  displayName: contactData['displayName'],
                  phoneNumber: contactData['phoneNumber'],
                  onTap: (Contact selectedContact) {
                    // Navigate back with the selected contact as a result.
                    Navigator.pop(context, selectedContact);
                  },
                );
              },
            ),
          )
          : FittedTextUI(text: 'No contacts found. Swipe down to refresh.', type: TextType.err),
      ),
    );
  }

  /// Load contacts from the Hive cache and update the UI.
  void loadContactsFromHive() {
    setState(() {
      // Fetch cached contacts using the Hive service.
      contacts = HiveService.getCachedContacts();
    });
  }

  /// Refresh the contact list by clearing and reloading the cache.
  Future<void> refreshContacts() async {
    setState(() {
      // Show the loading indicator while fetching new data.
      isFetching = true;
    });
    // Clear cached contacts and reload them.
    await HiveService.clearCachedContacts();
    await HiveService.loadContactsIfNeeded();
    // Reload contacts from the updated cache.
    loadContactsFromHive();
    setState(() {
      // Hide the loading indicator after refreshing.
      isFetching = false;
    });
  }
}
