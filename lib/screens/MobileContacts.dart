import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileContacts extends StatefulWidget {
  @override
  _MobileContactsState createState() => _MobileContactsState();
}

class _MobileContactsState extends State<MobileContacts> {
  List<Contact> contacts = [];
  ScrollController _scrollController = ScrollController();
  int currentBatchSize = 20;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    getContacts();  // Remove batchSize parameter

    // Add a listener to detect when the user scrolls to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoadingMore) {
        // Load more contacts when the user scrolls to the end
        loadMoreContacts();
      }
    });
  }

  // Fetch initial batch of contacts
  void getContacts() async {
    if (await Permission.contacts.request().isGranted) {
      try {
        Iterable<Contact> mobileContacts = await ContactsService.getContacts();
        setState(() {
          contacts = mobileContacts.take(currentBatchSize).toList();  // Take the first batch
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

  // Load more contacts when the user scrolls to the end
  void loadMoreContacts() async {
    setState(() {
      isLoadingMore = true;  // Set loading to true while fetching more data
    });
    try {
      Iterable<Contact> mobileContacts = await ContactsService.getContacts();
      int nextBatchSize = currentBatchSize + 20;  // Increase the batch size
      List<Contact> contactsToAdd = mobileContacts.take(nextBatchSize).toList();
      setState(() {
        contacts = contactsToAdd;
        currentBatchSize = nextBatchSize;
      });
    } catch (e) {
      print("Error fetching more contacts: $e");
    } finally {
      setState(() {
        isLoadingMore = false;  // Set loading to false after data is fetched
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Contacts'),
      ),
      body: contacts.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
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
                          Navigator.pop(context, contact);  // Pass selected contact back to the previous screen
                        },
                      );
                    },
                  ),
                ),
                if (isLoadingMore) // Show loading indicator when more contacts are being fetched
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
