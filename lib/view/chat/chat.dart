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
    print('Chat ID: ${widget.chat.id}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chat.name),
      ),
      body: Column(
        children: [
          Text('Chat page'), // Add this line
          Expanded(
            child: Container(
              child: StreamBuilder<List<Message>>(
                stream: _chatRepository.getMessagesForChat(widget.chat.id),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Message>> snapshot) {
                  print('Snapshot: $snapshot');
                  if (snapshot.hasData) {
                    print('Received messages: ${snapshot.data}');
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Message message = snapshot.data![index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          child: Align(
                            alignment: message.sender == widget.chat.users[0]
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: message.sender == widget.chat.users[0]
                                    ? Colors.grey.shade200
                                    : Colors.blue[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              child: Text(
                                message.message, // Change this line
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
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
