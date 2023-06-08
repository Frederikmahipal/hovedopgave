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
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PostRepository postRepository = PostRepository();

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
                  Text('${widget.creatorName}'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          // Form to add comments
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Indtast kommentar',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Indtast kommentar';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 16),
          // Submit button to add comments
          ElevatedButton(
            child: Text('Tilføj'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final Map<String, dynamic> commentData = {
                  'text': _commentController.text.trim(),
                };
                try {
                  await postRepository.addComment(
                    widget.teamID,
                    widget.postID,
                    commentData,
                    widget.creatorName,
                  );
                  _commentController.clear();
                } catch (e) {
                  print('Error adding comment: $e');
                }
              }
            },
          ),
    
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: postRepository.getCommentsForPost(
                  widget.teamID, widget.postID),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                    comments = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> comment = comments[index].data();
                    final Timestamp? timestamp =
                        comment['timestamp'] as Timestamp?;
                    final DateTime? dateTime = timestamp?.toDate();
                    String formattedDateTime = '';
                    if (dateTime != null) {
                      try {
                        formattedDateTime =
                            DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                      } catch (e) {
                        print('Error formatting timestamp: $e');
                      }
                    }
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
                            await postRepository.deleteCommentFromPost(
                                widget.teamID,
                                widget.postID,
                                comment['id'] as String);
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
