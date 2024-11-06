import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';  // Provides access to device contacts
import 'package:permission_handler/permission_handler.dart';  // Manages permissions for accessing contacts

/// Stateful widget to display and load contacts from the device
class MobileContacts extends StatefulWidget {
  @override
  _MobileContactsState createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  List<Contact> contacts = [];  // List to store loaded contacts
  ScrollController _scrollController = ScrollController();  // Controller to detect scroll position
  int currentBatchSize = 20;  // Initial batch size for loading contacts
  bool isLoadingMore = false;  // Indicator to show loading more contacts

  @override
  void initState() {
    super.initState();
    getContacts();  // Load initial batch of contacts

    // Add a listener to detect when the user scrolls to the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoadingMore) {
        loadMoreContacts();  // Load more contacts when the user reaches the end of the list
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();  // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Contacts'),  // Title of the screen
      ),
      body: contacts.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,  // Attach scroll controller for infinite scrolling
                    itemCount: contacts.length,  // Number of contacts to display
                    itemBuilder: (context, index) {
                      Contact contact = contacts[index];
                      String displayName = contact.displayName ?? 'No Name';  // Display contact name or placeholder
                      String phoneNumber = (contact.phones?.isNotEmpty ?? false)
                          ? contact.phones!.first.value ?? 'No Phone Number'
                          : 'No Phone Number';  // Display first phone number or placeholder

                      return ListTile(
                        title: Text(displayName),
                        subtitle: Text(phoneNumber),
                        onTap: () {
                          Navigator.pop(context, contact);  // Pass selected contact back to the previous screen
                        },
                      );
                    },
                  ),
                ),
                if (isLoadingMore) // Show loading indicator while fetching more contacts
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),  // Loading indicator while contacts are being loaded
            ),
    );
  }

  /// Fetch initial batch of contacts from the device
  void getContacts() async {
    if (await Permission.contacts.request().isGranted) {  // Check and request contact permission
      try {
        Iterable<Contact> mobileContacts = await ContactsService.getContacts();
        setState(() {
          contacts = mobileContacts.take(currentBatchSize).toList();  // Take the first batch of contacts
        });
      } catch (e) {
        print("Error fetching contacts: $e");  // Log error if fetching fails
      }
    } else {
      // Show permission error message if permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access contacts denied')),
      );
    }
  }

  /// Load additional contacts when user scrolls to the end
  void loadMoreContacts() async {
    setState(() {
      isLoadingMore = true;  // Set loading indicator to true
    });
    try {
      Iterable<Contact> mobileContacts = await ContactsService.getContacts();
      int nextBatchSize = currentBatchSize + 20;  // Increase batch size for additional contacts
      List<Contact> contactsToAdd = mobileContacts.take(nextBatchSize).toList();
      setState(() {
        contacts = contactsToAdd;  // Update the contact list with new batch
        currentBatchSize = nextBatchSize;  // Update current batch size
      });
    } catch (e) {
      print("Error fetching more contacts: $e");  // Log error if fetching fails
    } finally {
      setState(() {
        isLoadingMore = false;  // Reset loading indicator after data is fetched
      });
    }
  }
}
