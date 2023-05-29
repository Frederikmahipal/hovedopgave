import 'package:flutter/material.dart';
import 'package:hovedopgave_app/models/chat.dart';

import '../repository/chat_repository.dart';
import '../repository/user_repository.dart';
import 'chat/chat.dart';
import 'chat/createchat.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ChatRepository _chatRepository = ChatRepository();
  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<List<Chat>>(
        stream: _chatRepository.getChatsForUser(widget.userId),
        builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            List<Chat> chats = snapshot.data!;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (BuildContext context, int index) {
                Chat chat = chats[index];
                return ListTile(
                  title: Text(chat.name),
                  subtitle: FutureBuilder<List<String>>(
                    future: _getUserNames(chat.users),
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.join(', '));
                      } else {
                        return Container();
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(chat: chat),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateChatPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<List<String>> _getUserNames(List<String> userIds) async {
    List<String> userNames = [];
    for (String userId in userIds) {
      String userName = await _userRepository.getUserNameById(userId);
      userNames.add(userName);
    }
    return userNames;
  }
}
