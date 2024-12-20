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
  /// List of all contacts fetched from the Hive cache.
  List<Map<String, dynamic>> allContacts = [];

  /// Filtered list of contacts based on the search query.
  List<Map<String, dynamic>> filteredContacts = [];

  /// Indicates whether the app is currently fetching contacts.
  bool isFetching = false;

  /// Controller for the search input field.
  final TextEditingController searchController = TextEditingController();

  /// Indicates whether the search bar is visible.
  bool isSearchBarVisible = false;

  @override
  void initState() {
    super.initState();
    // Load cached contacts when the screen initializes.
    loadContactsFromHive();

    // Listen to search input changes.
    searchController.addListener(() {
      filterContacts(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar with a title and actions.
      appBar: AppBar(
        automaticallyImplyLeading: !isSearchBarVisible,
        title: isSearchBarVisible
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Contacts',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
            : const Text('Mobile Contacts'),
        backgroundColor: isSearchBarVisible
            ? Colors.deepPurple.shade700
            : Colors.deepPurpleAccent.shade700,
        actions: isSearchBarVisible
            ? [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSearchBarVisible = false;
                      searchController.clear();
                      filteredContacts = allContacts; // Reset to original list
                    });
                  },
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearchBarVisible = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: refreshContacts,
                ),
              ],
      ),

      // Main body of the screen.
      body: Column(
        children: [
          Expanded(
            child: MobileContactsUI(
              isFetching: isFetching,
              child: filteredContacts.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: refreshContacts,
                      child: ListView.builder(
                        // Number of contacts to display.
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          // Extract contact data for the current index.
                          final contactData = filteredContacts[index];

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

  /// Load contacts from the Hive cache and update the UI.
  void loadContactsFromHive() {
    setState(() {
      // Fetch cached contacts using the Hive service.
      allContacts = HiveService.getCachedContacts();
      filteredContacts = allContacts; // Initially, show all contacts.
    });
  }

  /// Filter contacts based on the search query.
  void filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredContacts = allContacts; // Show all contacts if query is empty.
      } else {
        filteredContacts = allContacts.where((contact) {
          final name = contact['displayName']?.toLowerCase() ?? '';
          final number = contact['phoneNumber']?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) || 
                 number.contains(query.toLowerCase());
        }).toList();
      }
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
