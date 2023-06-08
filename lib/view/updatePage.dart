import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../repository/user_repository.dart';


class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userRepository = UserRepository();

  void _updateUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      try {
        await user.updateDisplayName(name);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'name': name, 'email': email});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  void _deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      try {
        await _userRepository.deleteUser(uid);
        await user.delete();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Opdater profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Navn',
                  hintText: 'Indtast dit navn',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Indtast dit navn';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Indtast din email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email';
                  }
                  if (!value.contains('@')) {
                    return 'Email ikke gyldig';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateUser();
                  }
                },
                child: Text('Opdater'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _deleteUser();
                },
                child: Text('Slet konto'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
