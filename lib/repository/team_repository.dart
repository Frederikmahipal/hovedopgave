import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class TeamRepository {
  final CollectionReference teamCollection =
      FirebaseFirestore.instance.collection('teams');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> createTeam(String teamName, String teamInfo,
      {String? userId}) async {
    bool teamExists = await checkDuplicateTeamName(teamName);

    if (teamExists) {
      print('Team already exists with name: $teamName');
      return false;
    }

    DocumentReference teamDocRef =
        await FirebaseFirestore.instance.collection('teams').add({
      'teamName': teamName,
      'teamInfo': teamInfo,
      'members': [userId]
    });

    if (teamDocRef.id != null) {
      print('Team created with ID: \${teamDocRef.id}');
      return true;
    } else {
      print('Error creating team');
      return false;
    }
  }

  Future<void> joinTeam(String teamId, String userId) async {
    final teamDocRef =
        FirebaseFirestore.instance.collection('teams').doc(teamId);
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Add the 'joinedAt' field to the team document using 'set()' or 'update()'
    await teamDocRef.set(
        {'joinedAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));

    // Create a new document in the 'members' subcollection for the user
    await teamDocRef.collection('members').doc(userId).set({
      'userRef': userDocRef,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Object? Function()?> getTeam(String teamName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .where('name', isEqualTo: teamName)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    } else {
      DocumentSnapshot teamDoc = querySnapshot.docs[0];
      return teamDoc.data;
    }
  }

  Future<List<Map<String, dynamic>>> getAllTeams() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('teams').get();
    List<Map<String, dynamic>> teams = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['teamId'] = doc.id;
      teams.add(data);
    });
    return teams;
  }

  Future<bool> checkDuplicateTeamName(String teamName) async {
    final result = await FirebaseFirestore.instance
        .collection('teams')
        .where('teamName', isEqualTo: teamName)
        .get();

    return result.docs.isNotEmpty;
  }

  Future<List<String>> getMembersOfTeam(String teamId) async {
    final teamDocRef =
        FirebaseFirestore.instance.collection('teams').doc(teamId);
    final membersQuerySnapshot = await teamDocRef.collection('members').get();
    final List<String> membersList =
        membersQuerySnapshot.docs.map((doc) => doc.id).toList();
    return membersList;
  }

  Future<List<Map<String, dynamic>>> getTeamsForUser(String memberId) async {
  final teamsQuerySnapshot = await FirebaseFirestore.instance
      .collectionGroup('members')
      .where('userRef', isEqualTo: FirebaseFirestore.instance.doc('users/$memberId'))
      .get();

  final List<Map<String, dynamic>> teamsList = [];
  for (final memberDoc in teamsQuerySnapshot.docs) {
    final teamDocRef = memberDoc.reference.parent.parent;
    final teamDocSnapshot = await teamDocRef!.get();
    final teamData = teamDocSnapshot.data();
    final teamId = teamDocSnapshot.id;
    teamData!['teamID'] = teamId;
    teamsList.add(teamData);
  }

  return teamsList;
}


}
