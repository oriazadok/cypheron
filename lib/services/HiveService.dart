import 'package:hive_flutter/hive_flutter.dart';
import 'package:contacts_service/contacts_service.dart'; // Import for contacts service
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling
import 'dart:async';

import 'package:cypheron/models/UserModel.dart'; // Import the UserModel
import 'package:cypheron/models/ContactModel.dart';  // Import the ContactModel
import 'package:cypheron/models/MessageModel.dart';  // Import the MessageModel

/// A service class to handle database operations using Hive.
class HiveService {
  
  /// Initializes Hive and registers adapters for each model.
  static Future<void> init() async {
    await Hive.initFlutter();  // Initialize Hive for Flutter

    // Register adapters for each model to enable their use in Hive
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ContactModelAdapter());
    Hive.registerAdapter(MessageModelAdapter());
  }

  /// Adds a new user to the Hive 'users' box.
  /// Returns `true` if the user is successfully added, `false` otherwise.
  static Future<bool> addUser(UserModel user) async {
    try {
      var box = await Hive.openBox<UserModel>('users');  // Open the 'users' box
      await box.put(user.userId, user);  // Add the user with userId as the key
      await box.close();  // Close the box after the operation
      return true;  // Indicate successful addition
    } catch (error) {
      print('Error adding user: $error');
      return false;  // Indicate failure in case of error
    }
  }

  /// Retrieves a user by email from the Hive 'users' box.
  /// Returns the user if found, otherwise returns `null`.
  static Future<UserModel?> getUserByEmail(String email) async {
    var box = await Hive.openBox<UserModel>('users');  // Open the 'users' box

    try {
      // Search for the user with a matching email
      var user = box.values.firstWhere(
        (user) => user.email == email,
        orElse: () => throw StateError("No user found"),  // Exception if not found
      );
      return user;  // Return the found user
    } catch (e) {
      // Print error message and return null if no user found
      print("Error: $e");
      return null;
    }
  }

  /// Loads contacts from Hive by their IDs.
  /// Takes a list of contact IDs and returns a list of loaded contacts.
  static Future<List<ContactModel>> loadContactsByIds(List<String> contactIds) async {
    var box = await Hive.openBox<ContactModel>('contacts');  // Open the 'contacts' box

    List<ContactModel> loadedContacts = [];  // Initialize list for storing loaded contacts

    // Load each contact from Hive based on its ID and add to list if it exists
    for (String contactId in contactIds) {
      ContactModel? contact = box.get(contactId);  // Retrieve contact by ID
      if (contact != null) {
        loadedContacts.add(contact);  // Add to loadedContacts if found
      }
    }

    return loadedContacts;  // Return the list of loaded contacts
  }

  /// Saves a new contact and updates the associated user's contact list.
  /// Returns `true` if both operations succeed, `false` otherwise.
  static Future<bool> saveContact(UserModel user, ContactModel newContact) async {
    try {
      // Open the 'contacts' box to save the new contact
      var contactBox = await Hive.openBox<ContactModel>('contacts');
      
      // Save the new contact using its ID as the key
      await contactBox.put(newContact.id, newContact);

      // Update the user's contactIds list by adding the new contact's ID
      user.contactIds.add(newContact.id);

      // Open the 'users' box to save the updated user
      var userBox = await Hive.openBox<UserModel>('users');
      await userBox.put(user.userId, user);  // Save the updated user

      return true;  // Indicate success of the save operation
    } catch (e) {
      print('Error saving contact or updating user: $e');
      return false;  // Indicate failure in case of an error
    }
  }



  /// Loads contacts if needed based on the last updated timestamp.
  static Future<void> loadContactsIfNeeded() async {
    final contactsBox = await Hive.openBox('contactsBox');
    DateTime now = DateTime.now();
    DateTime? lastUpdated = contactsBox.get('lastUpdated') as DateTime?;

    if (lastUpdated == null || now.difference(lastUpdated).inHours >= 24) {
      print("Contacts are outdated or not loaded yet. Fetching contacts...");
      await _fetchAndStoreContacts();
    } else {
      print("Contacts are up-to-date.");
    }
  }

  /// Fetches and stores contacts in Hive.
  static Future<void> _fetchAndStoreContacts() async {
    final contactsBox = await Hive.openBox('contactsBox');

    if (await Permission.contacts.request().isGranted) {
      try {
        Iterable<Contact> mobileContacts = await ContactsService.getContacts(withThumbnails: false);
        List<Map<String, dynamic>> contactsList = mobileContacts.map((contact) {
          return {
            'displayName': contact.displayName ?? 'No Name',
            'phoneNumber': (contact.phones?.isNotEmpty ?? false) ? contact.phones!.first.value ?? 'No Phone Number' : 'No Phone Number',
          };
        }).toList();

        await contactsBox.put('contacts', contactsList);
        await contactsBox.put('lastUpdated', DateTime.now());
        print("Contacts stored in Hive: ${contactsList.length} contacts.");
      } catch (e) {
        print("Error fetching contacts: $e");
      }
    } else {
      print("Permission denied. Unable to fetch contacts.");
    }
  }

  /// Retrieves contacts from Hive.
  static List<Map<String, dynamic>> getCachedContacts() {
    final contactsBox = Hive.box('contactsBox');

    // Retrieve the contacts list and cast it to List<Map<String, dynamic>>
    final contacts = contactsBox.get('contacts', defaultValue: []);

    // Ensure each item is cast to Map<String, dynamic>
    return List<Map<String, dynamic>>.from(
      contacts.map((item) => Map<String, dynamic>.from(item)),
    );
  }


  /// Clears the cached contacts (for manual refresh).
  static Future<void> clearCachedContacts() async {
    final contactsBox = await Hive.openBox('contactsBox');
    await contactsBox.delete('contacts');
    await contactsBox.delete('lastUpdated');
    print("Cached contacts cleared.");
  }

}
