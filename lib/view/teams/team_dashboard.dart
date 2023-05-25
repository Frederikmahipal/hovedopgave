import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../repository/post_repository.dart';
import 'add_post.dart';

class TeamDashboard extends StatefulWidget {
  final String teamID;
  final PostRepository postRepository;

  const TeamDashboard(this.teamID, {required this.postRepository});

  @override
  _TeamDashboardState createState() => _TeamDashboardState();
}

class _TeamDashboardState extends State<TeamDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: widget.postRepository.getPostForCurrentTeam(widget.teamID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final posts = snapshot.data!.docs;
            if (posts.isNotEmpty) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index].data();
                  final creatorId = post['creator'];
                  return ListTile(
                      title: Text(post['title'] ?? ''),
                      subtitle: Text(post['content'] ?? ''),
                      trailing: Text(post['creator'] ?? ''));
                },
              );
            } else {
              return Center(
                child: Text('No posts found.'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPostScreen(widget.teamID),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
