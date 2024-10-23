class MessageModel {

  final String title;
  final String body;

  // Constructor to initialize the contact data
  MessageModel({
    required this.title,
    required this.body,
  });

  

  // Override the toString method for printing the contact details
  @override
  String toString() {
    return 'ContactModel{title: $title, body: $body';
  }
}
