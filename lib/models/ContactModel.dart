import 'MessageModel.dart';
import 'package:uuid/uuid.dart';  // Import the UUID package for generating unique IDs

class ContactModel {
  final String userId;
  final String id;  // Unique ID for each contact
  final String name;
  final String phoneNumber;
  List<MessageModel> messages;  // List of messages

  // Constructor to initialize the contact data
  ContactModel({
    required this.userId,
    String? id,  // Allow the ID to be optional so it can be generated if not provided
    required this.name,
    required this.phoneNumber,
    this.messages = const [],  // Default empty list for messages
  }) : id = id ?? Uuid().v4();  // Automatically generate a unique ID if not provided

  // Method to add a new message
  void addMessage(MessageModel message) {
    messages.add(message);
  }

  // Override the toString method for printing the contact details
  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, phoneNumber: $phoneNumber, messages: $messages}';
  }
}
