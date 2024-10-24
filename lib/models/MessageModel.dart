import 'package:hive/hive.dart';

part 'MessageModel.g.dart';  // Part file for the generated adapter

@HiveType(typeId: 2)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String body;

  // Constructor to initialize the message data
  MessageModel({
    required this.title,
    required this.body,
  });

  // Override the toString method for printing the message details
  @override
  String toString() {
    return 'MessageModel{title: $title, body: $body}';
  }
}
