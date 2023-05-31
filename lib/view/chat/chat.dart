import 'package:flutter/material.dart';
import 'package:hovedopgave_app/models/chat.dart';
import 'package:hovedopgave_app/repository/chat_repository.dart';
import 'package:hovedopgave_app/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chatbubble.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatRepository _chatRepository = ChatRepository();
  final UserRepository _userRepository = UserRepository();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Chat ID: ${widget.chat.id}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: StreamBuilder<List<Message>>(
                stream: _chatRepository.getMessagesForChat(widget.chat.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Message>> snapshot) {
                  if (snapshot.hasData) {
  return ListView.builder(
    reverse: true,
    itemCount: snapshot.data!.length,
    itemBuilder: (BuildContext context, int index) {
      Message message = snapshot.data![index];
      bool isCurrentUser = message.sender ==
          FirebaseAuth.instance.currentUser?.uid;
      return ChatBubble(
        text: message.message,
        userIndex: isCurrentUser ? 0 : 1,
        isCurrentUser: isCurrentUser,
        senderId: message.sender,
      );
    },
  );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: 0,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      final currentUser = _userRepository.getCurrentUser();
                      if (currentUser != null) {
                        _chatRepository.sendMessage(
                          widget.chat.id,
                          _messageController.text.trim(),
                          currentUser.uid,
                        );
                        _messageController.clear();
                      }
                    },
                    splashRadius: 24,
                    padding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
