import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hovedopgave_app/repository/user_repository.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final int userIndex;
  final bool isCurrentUser;
  final String senderId;

  ChatBubble({
    required this.text,
    required this.userIndex,
    required this.isCurrentUser,
    required this.senderId,
  });

  @override
  Widget build(BuildContext context) {
    final UserRepository _userRepository = UserRepository();

    return FutureBuilder(
      future: _userRepository.getUserById(senderId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final senderName = snapshot.data?.name ?? 'Unknown';

          return Column(
            crossAxisAlignment: userIndex == 0
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(senderName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  )),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isCurrentUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
