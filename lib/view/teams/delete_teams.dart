import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovedopgave_app/repository/team_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovedopgave_app/repository/team_repository.dart';

class DeleteTeamPage extends StatelessWidget {
  final TeamRepository _teamRepository = TeamRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slet hold'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _teamRepository.getAllTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(snapshot.data![index]['teamName']),
                    subtitle: Text(snapshot.data![index]['teamInfo']),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        String? teamId =
                            snapshot.data?[index]?['teamId'] as String?;
                        if (teamId != null) {
                          String userId = _auth.currentUser?.uid ?? '';
                          await _teamRepository.deleteTeam(teamId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('hold slettet'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text('slet'),
                    ));
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Kunne ikke indlæse hold'),
            );
          } else {
            return Center(
              child: Text('ingen hold fundet'),
            );
          }
        },
      ),
    );
  }
}

