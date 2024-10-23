import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hive/hive.dart';
// import 'package:cypheron/models/ContactModel.dart';  // Import ContactModel
// import 'package:cypheron/models/MessageModel.dart';  // Import MessageModel
// import 'package:uuid/uuid.dart';

import 'package:cypheron/models/UserModel.dart'; // The UserModel

class HiveService {

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register the adapter
    Hive.registerAdapter(UserModelAdapter());

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


}


  // // Open Hive box and load contacts
  // static Future<void> openHiveBox() async {
  //   contactBox = await Hive.openBox('contactsBox');
  //   print('Opened Hive box');
  // }

  // // Load contacts from Hive box (deserialize)
  // static List<ContactModel> loadContactsFromHive() {
  //   try {
  //     final storedContacts = contactBox?.get('contactsList') ?? [];
  //     print('Contacts loaded from Hive: $storedContacts');

  //     // Convert stored contacts to List<ContactModel>
  //     List<ContactModel> contactList = storedContacts.map<ContactModel>((contactData) {
  //       return ContactModel(
  //         id: contactData['id'] ?? Uuid().v4(),  // Ensure id is generated if missing
  //         name: contactData['name'] ?? 'No Name',
  //         phoneNumber: contactData['phone'] ?? 'No Phone',
  //         messages: (contactData['messages'] ?? []).map<MessageModel>((messageData) {
  //           return MessageModel(
  //             title: messageData['title'] ?? 'No Title',
  //             body: messageData['body'] ?? 'No Body',
  //           );
  //         }).toList(),
  //       );
  //     }).toList();

  //     print('Deserialized Contact List: $contactList');
  //     return contactList;
  //   } catch (error) {
  //     print('Error loading contacts from Hive: $error');
  //     return [];  // Return an empty list in case of error
  //   }
  // }

  // // Save contacts to Hive box (serialize)
  // static void saveContactsToHive(List<ContactModel> contactList) {
  //   try {
  //     final serializedContacts = contactList.map((contact) {
  //       return {
  //         'id': contact.id,
  //         'name': contact.name,
  //         'phone': contact.phoneNumber,
  //         'messages': contact.messages.map((message) {
  //           return {
  //             'title': message.title,
  //             'body': message.body,
  //           };
  //         }).toList(),
  //       };
  //     }).toList();
  //     contactBox?.put('contactsList', serializedContacts);
  //     print('Contacts saved to Hive: $serializedContacts');
  //   } catch (error) {
  //     print('Error saving contacts to Hive: $error');
  //   }
  // }

  // // Add a new message to a contact by id
  // static void addMessageToContact(String contactId, MessageModel newMessage) {
  //   try {
  //     // Load contacts from Hive
  //     List<ContactModel> contacts = loadContactsFromHive();

  //     // Find the contact by id
  //     ContactModel contact = contacts.firstWhere(
  //         (contact) => contact.id == contactId,
  //         orElse: () => throw Exception('Contact not found'));

  //     // Add the new message to the contact
  //     contact.addMessage(newMessage);

  //     // Save updated contacts back to Hive
  //     saveContactsToHive(contacts);

  //     print('Message added to contact: ${contact.name}');
  //   } catch (error) {
  //     print('Error adding message to contact: $error');
  //   }
  // }

