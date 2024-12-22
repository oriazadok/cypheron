import 'package:hive/hive.dart';

part 'UserModel.g.dart'; // Hive will generate this file

@HiveType(typeId: 0)  // Each class needs a unique typeId
class UserModel {
  @HiveField(0)
  final String userId;

  @HiveField(3)
  final String email;

  @HiveField(5)
  final List<String> contactIds;  // List of contact IDs

  // Constructor
  UserModel({
  required this.userId,
  required this.email,
  List<String>? contactIds,  // Nullable list input
})  : contactIds = contactIds ?? [];  // Assign an empty list if null

  // Override toString method for easy debugging
  @override
  String toString() {
    return 'UserModel{userId: $userId, email: $email, contactIds: $contactIds}';
  }
}
