import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hovedopgave_app/models/chat.dart';

import 'package:hovedopgave_app/repository/chat_repository.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatRepository _chatRepository = ChatRepository();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _chatRepository.getMessagesForChat(widget.chat.id),
              builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Message message = snapshot.data![index];
                      return ListTile(
                        title: Text(message.message),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd HH:mm:ss').format(message.timestamp),
                        ),
                        trailing: Text(message.sender),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _chatRepository.sendMessage(
                      widget.chat.id,
                      _messageController.text.trim(),
                      widget.chat.users[0],
                    );
                    _messageController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
