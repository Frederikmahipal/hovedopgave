import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/team_repository.dart';
import '../view-prelogin/login_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TeamRepository _teamRepository = TeamRepository();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
     
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _teamRepository.getTeamsForUser(_auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final teamsList = snapshot.data!;
            return ListView.builder(
              itemCount: teamsList.length,
              itemBuilder: (context, index) {
                final teamData = teamsList[index];
                return ListTile(
                  title: Text(teamData['teamName']),
                  subtitle: Text(teamData['teamInfo']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: \${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

