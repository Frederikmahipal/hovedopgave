import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovedopgave_app/view/teams/joinTeamPage.dart';
import 'package:hovedopgave_app/view/updatePage.dart';

import '../view-prelogin/login_screen.dart';
import 'teams/createTeamPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int selectedIndex = 2;

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Edit your info'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateProfilePage()),
              );
              // Handle option 1 tap
            },
          ),
          ListTile(
            title: Text('Create team'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle option 2 tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTeamPage()),
              );
            },
          ),
          // Add more ListTiles for other settings options
          ListTile(
            title: Text('Join team'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle option 2 tap
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JoinTeamPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _logout,
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }
}
