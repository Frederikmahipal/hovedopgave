import 'package:flutter/material.dart';
import 'package:hovedopgave_app/repository/team_repository.dart';
import 'package:hovedopgave_app/repository/user_repository.dart';
import 'package:hovedopgave_app/view/teams/createTeamPage.dart';
import 'package:hovedopgave_app/view/teams/joinTeamPage.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _userRepository = UserRepository();
  final TeamRepository _teamRepository = TeamRepository();

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<User>(
          stream: MyFirestoreService(uid: widget.userId).userData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print("NO DATA");
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            User user = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 16.0),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  user.email,
                  style:  TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateTeamPage()),
                          );
                        },
                        child: Text('create team'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JoinTeamPage()),
                          );
                        },
                        child: Text('join team'),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
