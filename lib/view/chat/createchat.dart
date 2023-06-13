import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../repository/chat_repository.dart';
import '../../repository/user_repository.dart';

class CreateChatPage extends StatefulWidget {
  @override
  _CreateChatPageState createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  final _userRepository = UserRepository();
  final _chatRepository = ChatRepository();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String? _userId = '';
  String? _selectedUserId;
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    final user = _userRepository.getCurrentUser();
    setState(() {
      if (user != null) {
        _userId = user.uid;
      } else {
        _userId = null;
      }
    });
    _userRepository.getAllUsers().then((users) {
      setState(() {
        _users = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter chat name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter chat name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<User>(
                value: null,
                decoration: const InputDecoration(
                  hintText: 'Select user',
                ),
                items: _users.map((user) {
                  return DropdownMenuItem<User>(
                    value: user,
                    child: Text(user.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUserId = value?.uid;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final users = [_userId!];
                    if (_selectedUserId != null) {
                      users.add(_selectedUserId!);
                    }
                    await _chatRepository.createChat(_name, users);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create Chat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
