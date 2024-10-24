import 'package:hive/hive.dart';
import 'MessageModel.dart';
import 'package:uuid/uuid.dart';  // Import the UUID package for generating unique IDs

part 'ContactModel.g.dart';  // This will be generated automatically for Hive

@HiveType(typeId: 1)
class ContactModel extends HiveObject {
  @HiveField(0)
  final String id;  // Unique ID for each contact

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  List<MessageModel> messages;  // List of messages

  // Constructor to initialize the contact data
  ContactModel({
    String? id,  // Allow the ID to be optional so it can be generated if not provided
    required this.name,
    required this.phoneNumber,
    this.messages = const [],  // Default empty list for messages
  }) : id = id ?? Uuid().v4();  // Automatically generate a unique ID if not provided

  // Method to add a new message
  void addMessage(MessageModel message) {
    messages.add(message);
    save();  // Automatically save after modifying the contact
  }

  // Override the toString method for printing the contact details
  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, phoneNumber: $phoneNumber, messages: $messages}';
  }
}
