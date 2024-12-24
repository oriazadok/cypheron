import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:cypheron/services/HiveService.dart';
import 'package:cypheron/widgets/search/SearchField.dart';
import 'package:cypheron/ui/screensUI/MobileContactsUI.dart';
import 'package:cypheron/ui/widgetsUI/cardsUI/MobileContactCardUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

class MobileContacts extends StatefulWidget {
  @override
  _MobileContactsState createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  List<Map<String, dynamic>> allContacts = []; // All contacts from Hive cache
  List<Map<String, dynamic>> filteredContacts = []; // Filtered contacts
  bool isFetching = false; // Indicates if contacts are being fetched
  bool isSearching = false; // Tracks if the search bar is active

  @override
  void initState() {
    super.initState();
    loadContactsFromHive(); // Load contacts on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isSearching, // Show back button if not searching
        title: isSearching
            ? SearchField(
                onChanged: (query) {
                  filterContacts(query); // Filter contacts on search query change
                },
                hintText: 'Search Contacts', // Placeholder text
              )
            : const Text('Mobile Contacts'), // Default app bar title
        actions: isSearching
          ? [
              IconsUI(
                type: IconType.close,
                onPressed: () {
                  setState(() {
                    isSearching = false; // Exit search mode
                    filteredContacts = allContacts; // Reset to original list
                  });
                },
              ),
            ]
          : [
              IconsUI(
                type: IconType.search,
                onPressed: () {
                  setState(() {
                    isSearching = true; // Enter search mode
                  });
                },
              ),
              IconsUI(
                type: IconType.refresh,
                onPressed: refreshContacts, // Refresh contacts
              ),
            ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileContactsUI(
              isFetching: isFetching,
              child: filteredContacts.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: refreshContacts, // Pull-to-refresh behavior
                      child: ListView.builder(
                        itemCount: filteredContacts.length, // Number of contacts
                        itemBuilder: (context, index) {
                          final contactData = filteredContacts[index];
                          return MobilecontactcardUI(
                            displayName: contactData['displayName'], // Contact name
                            phoneNumber: contactData['phoneNumber'], // Contact number
                            onTap: (Contact selectedContact) {
                              Navigator.pop(context, selectedContact); // Return selected contact
                            },
                          );
                        },
                      ),
                    )
                  : FittedTextUI(
                      text: 'No contacts found. Swipe down to refresh.',
                      type: TextType.err,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Loads contacts from the Hive cache and initializes the UI.
  void loadContactsFromHive() {
    setState(() {
      allContacts = HiveService.getCachedContacts(); // Fetch all cached contacts
      filteredContacts = allContacts; // Initially show all contacts
    });
  }

  /// Filters contacts based on the search query.
  void filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = allContacts; // Reset to original list if query is empty
      } else {
        filteredContacts = allContacts.where((contact) {
          final name = contact['displayName']?.toLowerCase() ?? ''; // Contact name
          final number = contact['phoneNumber']?.toLowerCase() ?? ''; // Contact number
          return name.contains(query.toLowerCase()) || 
                 number.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  /// Refreshes the contact list by clearing and reloading the cache.
  Future<void> refreshContacts() async {
    setState(() {
      isFetching = true; // Show loading indicator
    });
    await HiveService.clearCachedContacts(); // Clear cached contacts
    await HiveService.loadContactsIfNeeded(); // Reload contacts
    loadContactsFromHive(); // Load contacts from updated cache
    setState(() {
      isFetching = false; // Hide loading indicator
    });
  }
}
