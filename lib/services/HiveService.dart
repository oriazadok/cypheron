import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:uuid/uuid.dart';

import 'package:cypheron/models/UserModel.dart'; // The UserModel
import 'package:cypheron/models/ContactModel.dart';  // Import ContactModel
import 'package:cypheron/models/MessageModel.dart';  // Import MessageModel

class HiveService {

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register the adapter
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ContactModelAdapter());
    Hive.registerAdapter(MessageModelAdapter());


  }

  static Future<bool> addUser(UserModel user) async {
    try {
      var box = await Hive.openBox<UserModel>('users');  // Open box
      await box.put(user.userId, user);  // Perform operation
      await box.close();  // Close the box after the operation
      return true;  // Return true if the user was added successfully
    } catch (error) {
      print('Error adding user: $error');
      return false;  // Return false if there was an error
    }
  }

  // Function to retrieve a user by email asynchronously
  static Future<UserModel?> getUserByEmail(String email) async {
    var box = await Hive.openBox<UserModel>('users');  // Open the box asynchronously

    try {
      // Find user with the matching email
      var user = box.values.firstWhere(
        (user) => user.email == email,
        orElse: () => throw StateError("No user found"),  // Throw exception if not found
      );
      
      return user;  // Return user if found
    } catch (e) {
      // Print the error and return null if not found
      print("Error: $e");
      return null;
    }
  }

  // Load contacts from Hive using their contact IDs
  static Future<List<ContactModel>> loadContactsByIds(List<String> contactIds) async {
    var box = await Hive.openBox<ContactModel>('contacts');  // Open the 'contacts' box

    List<ContactModel> loadedContacts = [];  // List to store loaded contacts

    // Iterate over each contact ID and load the corresponding contact from Hive
    for (String contactId in contactIds) {
      ContactModel? contact = box.get(contactId);  // Get the contact by its ID
      if (contact != null) {
        loadedContacts.add(contact);  // Add to list if it exists
      }
    }

    return loadedContacts;  // Return the list of loaded contacts
  }

  // Function to save a contact and update the user's contact list
  static Future<bool> saveContact(UserModel user, ContactModel newContact) async {
    try {
      // Open the contacts box
      var contactBox = await Hive.openBox<ContactModel>('contacts');
      
      // Save the contact to Hive
      await contactBox.put(newContact.id, newContact);

      // After saving the contact, update the user's contactIds list
      user.contactIds.add(newContact.id);

      // Now, open the user box to update the user
      var userBox = await Hive.openBox<UserModel>('users');
      await userBox.put(user.userId, user);  // Save the updated user with the new contact ID

      // Close both boxes after operation
      await contactBox.close();
      await userBox.close();

      return true;  // Return success
    } catch (e) {
      print('Error saving contact or updating user: $e');
      return false;  // Return failure in case of any error
    }
  }


}
