import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../repository/post_repository.dart';

class PostDashboard extends StatefulWidget {
  final String teamID;
  final String postID;
  final String postTitle;
  final String postContent;
  final String creatorName;

  const PostDashboard({
    required this.teamID,
    required this.postID,
    required this.postTitle,
    required this.postContent,
    required this.creatorName,
  });

  @override
  _PostDashboardState createState() => _PostDashboardState();
}

class _PostDashboardState extends State<PostDashboard> {
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postRepository = PostRepository();

    return Scaffold(
      appBar: AppBar(title: Text(widget.postTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.postContent),
                  SizedBox(height: 16),
                  Text('Created by: ${widget.creatorName}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('Add Comment', style: Theme.of(context).textTheme.headline6),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your comment',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a comment';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Submit'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final commentData = {
                  'text': _commentController.text.trim(),
                };
                await postRepository.addComment(
                  widget.teamID,
                  widget.postID,
                  commentData,
                  widget.creatorName,
                );
                _commentController.clear();
              }
            },
          ),
          SizedBox(height: 16),
          Text('Comments', style: Theme.of(context).textTheme.headline6),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: postRepository.getCommentsForPost(widget.teamID, widget.postID),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index].data();
                    final timestamp = comment['timestamp'] as Timestamp;
                    final dateTime = timestamp.toDate();
                    final formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.comment),
                        title: Text(comment['text'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment['user'] ?? ''),
                            Text(formattedDateTime),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await postRepository.deleteCommentFromPost(widget.teamID, widget.postID, comment['id'] as String);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
