import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'UserModel.g.dart'; // Hive will generate this file

@HiveType(typeId: 0)  // Each class needs a unique typeId
class UserModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String hashedPassword;

  @HiveField(5)
  final List<String> contactIds;  // List of contact IDs

  // Constructor
  UserModel({
  String? userId,
  required this.name,
  required this.phoneNumber,
  required this.email,
  required this.hashedPassword,
  List<String>? contactIds,  // Nullable list input
})  : userId = userId ?? Uuid().v4(),
      contactIds = contactIds ?? [];  // Assign an empty list if null

  // Override toString method for easy debugging
  @override
  String toString() {
    return 'UserModel{userId: $userId, name: $name, phoneNumber: $phoneNumber, email: $email, password: $hashedPassword, contactIds: $contactIds}';
  }
}
