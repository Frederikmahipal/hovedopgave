import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column();
          },
        ),
      ),
    );
  }
}
