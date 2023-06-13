import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovedopgave_app/view-prelogin/login_screen.dart';
import '../repository/user_repository.dart';

class signupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<signupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oprettelse'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Navn',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Indtast dit navn';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'indtast email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'indtast adgangskode';
                }
                return null;
              },
            ),
            ElevatedButton(
              child: const Text('Opret dig'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    User? user = result.user;
                    await _userRepository.createUser(user!.uid, _nameController.text, _emailController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } catch (error) {
                    print(error);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
