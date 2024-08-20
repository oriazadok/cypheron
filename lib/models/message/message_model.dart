class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final bool isEncrypted;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.isEncrypted,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'isEncrypted': isEncrypted ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
