import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hovedopgave_app/models/chat.dart';

import 'package:hovedopgave_app/repository/user_repository.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRepository _userRepository = UserRepository();
  final _chatCollection = FirebaseFirestore.instance.collection('chats');

  Stream<List<Chat>> getChatsForUser(String userId) {
    return _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Chat.fromSnapshot(doc)).toList());
  }

  Stream<List<Message>> getMessagesForChat(String chatId) {
  print('Getting messages for chat $chatId');
  return _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((QuerySnapshot querySnapshot) {
    List<Message> messages = [];
    querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
      messages.add(Message.fromSnapshot(documentSnapshot));
    });
    print('Received ${messages.length} messages');
    return messages;
  });
}


Future<String> deleteChat(String chatId) async {
  await _firestore
      .collection('chats')
      .doc(chatId)
      .delete();
  return chatId;
}



  Future<void> sendMessage(String chatId, String message, String senderId) async {
    final messageDoc =
        _firestore.collection('chats').doc(chatId).collection('messages').doc();
    final messageData = {
      'id': messageDoc.id,
      'message': message,
      'sender': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    };
    await messageDoc.set(messageData);
  }


  Future<void> createChat(String name, List<String> users) async {
    final chatDoc = _chatCollection.doc();
    final chatData = {'name': name, 'users': users};
    await chatDoc.set(chatData);
  }
}
