import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view-prelogin/login_screen.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_screen';

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          await _auth.signOut();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Text('Logout'),
      ),
    );
  }
}
