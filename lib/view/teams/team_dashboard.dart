 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../reusable-widgets/post_form.dart';
import 'add_post.dart';

class TeamDashboard extends StatefulWidget {
  final Map<String, dynamic> teamData;

  TeamDashboard(this.teamData);

  @override
  _TeamDashboardState createState() => _TeamDashboardState();
}

class _TeamDashboardState extends State<TeamDashboard> {
  final _postRepository = FirebaseFirestore.instance.collection('posts');

  void _navigateToAddPostScreen() async {
    final message = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostScreen(widget.teamData),
      ),
    );
    if (message != null && message.isNotEmpty) {
      _postRepository.add({
        'teamId': widget.teamData['teamId'],
        'message': message,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teamData['teamName']),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _postRepository
            .where('teamId', isEqualTo: widget.teamData['teamId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final postsList = snapshot.data!.docs;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: postsList.length,
                  itemBuilder: (context, index) {
                    final postData =
                        postsList[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title:
                          Text(postData['message']?.toString() ?? 'No message'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _navigateToAddPostScreen,
                child: Text('Create Post'),
              ),
            ],
          );
        },
      ),
    );
  }
}
