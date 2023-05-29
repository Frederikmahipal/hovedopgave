import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String name;
  final List<String> users;
  final List<String> userNames;

  Chat({
    required this.id,
    required this.name,
    required this.users,
    required this.userNames,
  });

  factory Chat.fromSnapshot(DocumentSnapshot snapshot) {
    return Chat(
      id: snapshot.id,
      name: snapshot['name'],
      users: List<String>.from(snapshot['users']),
      userNames: [], // Initialize to empty list
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'users': users,
    };
  }
}





class Message {
  final String id;
  final String message;
  final String sender;
  final DateTime timestamp;
  final String chatId;

  Message({
    required this.id,
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.chatId,
  });

  factory Message.fromSnapshot(DocumentSnapshot snapshot) {
    return Message(
      id: snapshot.id,
      message: snapshot['message'],
      sender: snapshot['sender'],
      timestamp: (snapshot['timestamp'] as Timestamp).toDate(),
      chatId: snapshot['chatId'],
    );
  }
}
