import 'package:flutter/material.dart';

class PostForm extends StatefulWidget {
  final String teamId;

  PostForm(this.teamId, {required Null Function(dynamic message) onSubmit});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  void _submitPost() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add post to Firestore database
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your post here',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitPost,
                child: Text('Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
