import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/services/HiveService.dart';
import 'package:cypheron/widgets/search/SearchField.dart';
import 'package:cypheron/ui/screensUI/MobileContactsUI.dart';
import 'package:cypheron/ui/widgetsUI/cardsUI/MobileContactCardUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

/// The main screen for displaying mobile contacts.
class MobileContacts extends StatefulWidget {
  @override
  _MobileContactsState createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  /// Stores all contacts fetched from the Hive cache.
  List<Map<String, dynamic>> allContacts = [];

  /// Stores the filtered contacts based on the search query.
  List<Map<String, dynamic>> filteredContacts = [];

  /// Tracks whether the app is currently fetching contacts.
  bool isFetching = false;

  /// Tracks whether the search bar is active.
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadContactsFromHive(); // Load contacts when the screen initializes.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar with search functionality and refresh options.
      appBar: AppBar(
        automaticallyImplyLeading: !isSearching, // Show back button if not in search mode.
        title: isSearching
            ? SearchField(
                onChanged: (query) {
                  filterContacts(query); // Filter contacts as user types.
                },
                hintText: 'Search Contacts', // Placeholder for the search bar.
              )
            : const Text('Mobile Contacts'), // Title when not searching.
        actions: isSearching
          ? [
              // Close button for search mode.
              IconsUI(
                type: IconType.close,
                onPressed: () {
                  setState(() {
                    isSearching = false; // Exit search mode.
                    filteredContacts = allContacts; // Reset to original list.
                  });
                },
              ),
            ]
          : [
              // Search button to enter search mode.
              IconsUI(
                type: IconType.search,
                onPressed: () {
                  setState(() {
                    isSearching = true; // Enter search mode.
                  });
                },
              ),
              // Refresh button to reload contacts.
              IconsUI(
                type: IconType.refresh,
                onPressed: refreshContacts,
              ),
            ],
      ),

      /// Main body displaying the contact list or a message if no contacts are found.
      body: Column(
        children: [
          Expanded(
            child: MobileContactsUI(
              isFetching: isFetching, // Displays loading indicator if fetching.
              child: filteredContacts.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: refreshContacts, // Pull-to-refresh behavior.
                      child: ListView.builder(
                        itemCount: filteredContacts.length, // Number of contacts.
                        itemBuilder: (context, index) {
                          final contactData = filteredContacts[index];
                          return MobilecontactcardUI(
                            displayName: contactData['displayName'], // Contact name.
                            phoneNumber: contactData['phoneNumber'], // Contact number.
                            onTap: (Contact selectedContact) {
                              String contactName = selectedContact.displayName ?? 'No Name';
                              String contactPhone = (selectedContact.phones?.isNotEmpty ?? false)
                                  ? selectedContact.phones!.first.value ?? 'No Phone'
                                  : 'No Phone';
                              ContactModel newContact = ContactModel(
                                name: contactName,
                                phoneNumber: contactPhone,
                              );
                              Navigator.pop(context, newContact); // Return selected contact.
                            },
                          );
                        },
                      ),
                    )
                  : Center(
                      /// Message displayed when no contacts are found.
                      child: FittedTextUI(
                        text: 'No contacts found. Swipe down to refresh.',
                        type: TextType.err,
                      ),
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
      allContacts = HiveService.getCachedContacts(); // Fetch cached contacts.
      filteredContacts = allContacts; // Initially display all contacts.
    });
  }

  /// Filters the contacts based on the search query.
  void filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        // Reset to the original list if the query is empty.
        filteredContacts = allContacts;
      } else {
        // Filter contacts by matching the query with name or number.
        filteredContacts = allContacts.where((contact) {
          final name = contact['displayName']?.toLowerCase() ?? ''; // Contact name.
          final number = contact['phoneNumber']?.toLowerCase() ?? ''; // Contact number.
          return name.contains(query.toLowerCase()) || 
                 number.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  /// Refreshes the contact list by clearing the cache and reloading.
  Future<void> refreshContacts() async {
    setState(() {
      isFetching = true; // Display loading indicator during refresh.
    });
    await HiveService.clearCachedContacts(); // Clear existing cached contacts.
    await HiveService.loadContactsIfNeeded(); // Reload contacts from the source.
    loadContactsFromHive(); // Refresh the displayed list.
    setState(() {
      isFetching = false; // Hide loading indicator after refresh.
    });
  }
}
