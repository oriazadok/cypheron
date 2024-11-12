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
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: isFetching ? null : refreshContacts,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C1E), Color(0xFF2C2C34)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isFetching
            ? Center(child: CircularProgressIndicator(color: Colors.white))
            : contacts.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: refreshContacts,
                    child: ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contactData = contacts[index];
                        String displayName = contactData['displayName'];
                        String phoneNumber = contactData['phoneNumber'];

                        return _buildContactCard(displayName, phoneNumber);
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      'No contacts found. Swipe down to refresh.',
                      style: TextStyle(fontSize: 18, color: Colors.redAccent),
                    ),
                  ),
      ),
    );
  }

  /// Builds a custom contact card with improved styling
  Widget _buildContactCard(String displayName, String phoneNumber) {
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
            // Convert simplified contact data back to a Contact object
            Contact selectedContact = Contact(
              displayName: displayName,
              phones: [Item(label: 'mobile', value: phoneNumber)],
            );
            Navigator.pop(context, selectedContact);
          },
        ),
      ),
    );
  }
}
