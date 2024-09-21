class Message {
  final String chatRoomId;
  final String senderUserId;
  final String receiverUserId;
  final String content;
  final DateTime createdAt;

  Message({
    required this.chatRoomId,
    required this.senderUserId,
    required this.receiverUserId,
    required this.content,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      chatRoomId: json['chatRoomId'],
      senderUserId: json['senderUserId'],
      receiverUserId: json['receiverUserId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'senderUserId': senderUserId,
      'receiverUserId': receiverUserId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}