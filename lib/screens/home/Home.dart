import 'package:flutter/material.dart';

import 'package:cypheron/services/FireBaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cypheron/services/HiveService.dart';
import 'package:cypheron/models/UserModel.dart';
import 'package:cypheron/models/ContactModel.dart';

import 'package:cypheron/ui/screensUI/HomeUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/OpsRowUI.dart';

import 'package:cypheron/widgets/dialogs/ExitConfirmationDialog.dart';
import 'package:cypheron/widgets/search/SearchField.dart';
import 'package:cypheron/widgets/lists/ContactsList.dart';
import 'package:cypheron/widgets/buttons/AddContactButton.dart';

import 'package:cypheron/screens/welcome/Welcome.dart';
import 'package:cypheron/screens/Contact_info/ContactInfo.dart';

/// The main Home screen for the app, displaying user contacts.
class Home extends StatefulWidget {
  final User user;
  final UserModel userModel; // Represents the currently logged-in user.

  Home({ required this.user, required this.userModel });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>  with WidgetsBindingObserver{
  List<ContactModel> contactList = []; // Stores all contacts.

  bool isSearching = false; // Tracks if the user is in search mode.
  String searchQuery = ''; // Stores the current search query.
  List<ContactModel> filteredContactList = []; // Stores filtered contacts based on search.

  bool isSaving = false; // Tracks if a save operation is in progress.
  
  ContactModel? selectedContact; // Tracks the currently selected contact.

  DateTime? _sessionStartTime; // Tracks the session start time.

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this); // Start observing lifecycle changes.
    _sessionStartTime = DateTime.now(); // Start the session timer.

    _loadContactsByIds(widget.userModel.contactIds);  
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Stop observing lifecycle changes.
    _updateAnalyticsData(); // Ensure analytics data is updated on exit.
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _updateAnalyticsData(); // Update analytics when the app is paused or inactive.
    } else if (state == AppLifecycleState.resumed) {
      _sessionStartTime = DateTime.now(); // Restart the session timer on resume.
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: Scaffold(
        appBar: AppBar(
          title: isSearching
              ? SearchField(
                  onChanged: (value) {
                    _filterContacts(value);
                  },
                )
              : const Text("Cypheron"),
          actions: _buildAppBarActions(),
        ),
        body: HomeUI(
          isSaving: isSaving,
          children: [
            ContactList(
              contactList: filteredContactList,
              onTap: (ContactModel contact) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactInfo(user: widget.user, contact: contact),
                  ),
                );
              },
              onLongPress: (ContactModel contact) {
                isSearching = false;
                setState(() {
                  selectedContact = contact;
                });
              },
              selectedContact: selectedContact,
            ),
            if (selectedContact != null)
              OpsRowUI(
                options: [
                  IconsUI(
                    type: IconType.delete,
                    onPressed: () => _deleteContact(selectedContact!),
                  )
                ],
              ),
          ],
        ),
        floatingActionButton: selectedContact == null
            ? AddContactButton(onAddContact: _addNewContact)
            : null,
      ),
    );
  }

  /// Loads contacts from Hive storage based on user-provided IDs.
  Future<void> _loadContactsByIds(List<String> contactIds) async {
    setState(() {
      isSaving = true;
    });
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts; // Updates the contact list.
      filteredContactList = loadedContacts; // Initializes the filtered list.
      isSaving = false;
    });
  }

  List<Widget> _buildAppBarActions() {
    if (!isSearching) {
        if (selectedContact == null) {
        
          return [
              IconsUI(
                type: IconType.search,
                onPressed: () {
                  setState(() {
                    isSearching = true;
                  });
                },
              ),
              IconsUI(
                type: IconType.logout,
                onPressed: () async {
                  await _confirmLogout();
                },
              ),
          ];
        }
    } else {
      return [
        IconsUI(
          type: IconType.close,
          onPressed: () {
            setState(() {
              isSearching = false;
              searchQuery = '';
              filteredContactList = List.from(contactList);
            });
          },
        ),
      ];
    }

    return [];
  }

  /// Handles back button to cancel deletion mode, exit search, or show logout dialog.
  Future<bool> _handleBackButton() async {
    if (selectedContact != null) {
      setState(() {
        selectedContact = null; // Deselect contact.
      });
      return false; // Prevent app exit.
    }

    if (isSearching) {
      setState(() {
        isSearching = false; // Exit search mode.
        searchQuery = ''; // Clear search query.
        filteredContactList = List.from(contactList); // Reset list.
      });
      return false; // Prevent app exit.
    }

    return await _confirmLogout(); // Show logout confirmation.
  }

  /// Shows a confirmation dialog before logging out.
  Future<bool> _confirmLogout() async {
    final shouldLogOut = await showDialog<bool>(
      context: context,
      builder: (context) => ExitConfirmationDialog(
        onConfirm: () async {
          Navigator.of(context).pop(true); // Confirms logout.
        },
      ),
    );

    if (shouldLogOut == true) {
      await _logOut(context); // Logs out the user.
    }

    return shouldLogOut ?? false;
  }

  /// Logs the user out and navigates to the Welcome screen.
  Future<void> _logOut(BuildContext context) async {
    try {
      await FireBaseService.signOut(); // Firebase logout.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Welcome()), // Redirect to Welcome screen.
        (route) => false,
      );
    } catch (e) {
      // Shows an error message if logout fails.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  /// Filters contacts based on the user's search query.
  void _filterContacts(String query) {
    setState(() {
      searchQuery = query; // Updates the search query.
      filteredContactList = contactList
          .where((contact) =>
              contact.name.toLowerCase().contains(query.toLowerCase())) // Filters contacts.
          .toList();
    });
  }

  /// Adds a new contact and saves it to Hive storage.
  void _addNewContact(ContactModel newContact) async {
    if (contactList.any((contact) =>
      contact.name.toLowerCase() == newContact.name.toLowerCase() &&
      contact.phoneNumber == newContact.phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact already exists.')),
      );
      return;
    }

    // Temporarily add the contact to the list and show saving indicator
    setState(() {
      contactList.add(newContact); // Adds the contact locally.
      filteredContactList = List.from(contactList); // Updates the filtered list.
      isSaving = true; // Indicates a save operation.
    });

    try {
      // Save the contact to Firebase
      bool firebaseSuccess = await FireBaseService.saveContactToFirebase(widget.user.uid, newContact);

      if (firebaseSuccess) {
        // Save the contact to Hive
        bool hiveSuccess = await HiveService.saveContact(widget.userModel, newContact);

        if (hiveSuccess) {
          // Both Firebase and Hive succeeded
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Contact saved successfully.')),
          // );
        } else {
          // Hive failed, revert Firebase save
          await FireBaseService.deleteContactFromFirebase(widget.user.uid, newContact);

          setState(() {
            contactList.remove(newContact);
            filteredContactList = List.from(contactList);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to save contact locally. Reverted.')),
          );
        }
      } else {
        // Firebase failed
        setState(() {
          contactList.remove(newContact);
          filteredContactList = List.from(contactList);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save contact to Cloud.')),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      print("Error adding contact: $e");
      setState(() {
        contactList.remove(newContact);
        filteredContactList = List.from(contactList);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    } finally {
      // Reset saving indicator
      setState(() {
        isSaving = false;
      });
    }
  }

  /// Deletes a selected contact and updates the list.
  void _deleteContact(ContactModel contactToDelete) async {
    setState(() {
      contactList.remove(contactToDelete); // Remove the contact locally from the list.
      filteredContactList = List.from(contactList); // Update the filtered list.
      selectedContact = null; // Clear the selected contact.
      isSaving = true; // Indicate the deletion operation is in progress.
    });

    try {
      // Delete the contact from Firebase
      bool firebaseSuccess = await FireBaseService.deleteContactFromFirebase(widget.user.uid, contactToDelete);

      if (firebaseSuccess) {
        // Proceed to delete the contact from Hive
        bool hiveSuccess = await HiveService.deleteContact(widget.userModel, contactToDelete);

        if (hiveSuccess) {
          // Both Firebase and Hive deletions succeeded
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Contact deleted successfully.')),
          // );
        } else {
          // Hive deletion failed; revert Firebase deletion
          await FireBaseService.saveContactToFirebase(widget.user.uid, contactToDelete);

          setState(() {
            contactList.add(contactToDelete); // Revert local deletion.
            filteredContactList = List.from(contactList);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete contact from device. Reverted.'),
            ),
          );
        }
      } else {
        // Firebase deletion failed; revert local deletion
        setState(() {
          contactList.add(contactToDelete); // Revert local deletion.
          filteredContactList = List.from(contactList);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete contact from Cloud.')),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      print("Error deleting contact: $e");

      setState(() {
        contactList.add(contactToDelete); // Revert local deletion.
        filteredContactList = List.from(contactList);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    } finally {
      // Reset saving indicator
      setState(() {
        isSaving = false;
      });
    }
  }

  void _updateAnalyticsData() async {
    if (_sessionStartTime == null) return;

    final sessionEndTime = DateTime.now(); // End of the current session
    final durationInSeconds = sessionEndTime.difference(_sessionStartTime!).inSeconds;

    // Calculate the duration in minutes as a fractional value
    final durationInMinutes = durationInSeconds / 60.0;

    // Reference the user's Firestore document
    final doc = FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    final snapshot = await doc.get();

    if (snapshot.exists) {
      final currentTotal = snapshot.data()?['analyticsData']['totalTimeSpent'] ?? 0.0; // Default to 0.0 minutes
      final sessions = snapshot.data()?['analyticsData']['sessions'] ?? [];

      // Add the new session details (without endTime)
      final updatedSessions = [
        ...sessions,
        {
          "startTime": _sessionStartTime!.toIso8601String(),
          "duration": durationInMinutes
        }
      ];

      // Update Firestore with the total time spent, last active time, and session details
      await doc.update({
        "analyticsData.totalTimeSpent": currentTotal + durationInMinutes,
        "analyticsData.lastActive": sessionEndTime.toIso8601String(),
        "analyticsData.sessions": updatedSessions,
      });
    }

    // Reset session start time
    _sessionStartTime = null;
  }

}
