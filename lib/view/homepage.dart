import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovedopgave_app/repository/post_repository.dart';
import 'package:hovedopgave_app/repository/user_repository.dart';
import '../repository/team_repository.dart';
import '../view-prelogin/login_screen.dart';
import '../view/teams/team_dashboard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TeamRepository _teamRepository = TeamRepository();
  final PostRepository _postRepository = PostRepository();
  final UserRepository _userRepository = UserRepository();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser!.uid;
    const welcomeMessage = 'Velkommen!';
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _userRepository.getUserNameById(uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final displayName = snapshot.data!;
              final welcomeMessage = 'Velkommen $displayName ';
              return Text(welcomeMessage);
            } else {
              return const Text(welcomeMessage);
            }
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _teamRepository.getTeamsForUser(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final teamsList = snapshot.data!;
            return ListView.builder(
              itemCount: teamsList.length,
              itemBuilder: (context, index) {
                final teamData = teamsList[index];
                return InkWell(
                  onTap: () {
                    print('teamData: $teamData');
                    print('teamID: ${teamData['teamID']}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDashboard(
                          teamData['teamID'],
                          postRepository: _postRepository,
                          teamRepository: _teamRepository,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(teamData['teamName']),
                    subtitle: Text(teamData['teamInfo']),
                  ),
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
