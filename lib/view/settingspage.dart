import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovedopgave_app/auth/auth_repository.dart';
import 'package:hovedopgave_app/view/teams/delete_teams.dart';
import 'package:hovedopgave_app/view/updatePage.dart';

import '../repository/user_repository.dart';
import '../view-prelogin/login_screen.dart';
import 'teams/createTeamPage.dart';
import 'teams/joinTeamPage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();
  int selectedIndex = 2;
  bool _isAdmin = false; 

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indstillinger'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Opdater din info'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateProfilePage()),
              );
            },
          ),
          Visibility(
            visible: _isAdmin,
            child: ListTile(
              title: Text('Opret hold'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTeamPage()),
                );
              },
            ),
          ),
          Visibility(
            visible: _isAdmin,
            child: ListTile(
              title: Text('Slet hold'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteTeamPage()),
                );
              },
            ),
          ),
          ListTile(
            title: Text('Tilmeld hold'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JoinTeamPage()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          child: ListTile(
        title: Text('Logud'),
        trailing: Icon(Icons.logout),
        onTap: () {
          _authRepository.logout();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      )),
    );
  }


Future<void> _fetchCurrentUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      _isAdmin = await UserRepository()
          .getUserRole(userId); 
      setState(() {});
    }
  }

}

