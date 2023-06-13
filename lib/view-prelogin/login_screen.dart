import 'package:flutter/material.dart';
import 'package:hovedopgave_app/view-prelogin/signup_screen.dart';

import 'package:hovedopgave_app/view/homepage.dart';

import '../auth/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log ind'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'indtast din email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Adgangskode',
              ),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Indtast din adgangskode';
                }
                return null;
              },
            ),
            ElevatedButton( 
              child: const Text('Log ind'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await _authRepository.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (error) {
                    print(error);
                  }
                }
              },
            ),    
             SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => signupScreen())
                  );
                },
                child: Text("Opret konto")),
          ],
        ),
      ),
    );
  }
}
