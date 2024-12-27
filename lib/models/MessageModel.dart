import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

part 'MessageModel.g.dart'; // Part file for the generated adapter

@HiveType(typeId: 2)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id; // Unique ID for each message

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime timestamp; // Timestamp field

  // Constructor to initialize the message data
  MessageModel({
    String? id,
    required this.title,
    required this.body,
    DateTime? timestamp,
  })  : id = id ?? Uuid().v4(), // Generate a unique ID if not provided
        timestamp = timestamp ?? DateTime.now(); // Default to current time

  // Override the toString method for printing the message details
  @override
  String toString() {
    return 'MessageModel{id: $id, title: $title, body: $body, timestamp: $timestamp}';
  }
}
