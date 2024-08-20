class ContactModel {
  final String id;
  final String name;
  final String? profilePicture;
  final String? lastMessage;

  ContactModel({
    required this.id,
    required this.name,
    this.profilePicture,
    this.lastMessage,
  });
}
