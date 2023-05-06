import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hovedopgave_app/repository/team_repository.dart';

class CreateTeamPage extends StatefulWidget {
  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final _formKey = GlobalKey<FormState>();
  final TeamRepository _teamRepository = TeamRepository();

  String _teamName = '';
  String _teamInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Team Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _teamName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Team Info',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter team info';
                  }
                  return null;
                },
                onSaved: (value) {
                  _teamInfo = value!;
                },
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        bool teamCreated = await _teamRepository.createTeam(
                            _teamName, _teamInfo);

                        if (teamCreated) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Team created')),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Team name already exists')),
                          );
                        }
                      }
                    },
                    child: const Text('Create Team'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
