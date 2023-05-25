import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createPost(String teamID, Map<String, dynamic> postData) async {
    final user = FirebaseAuth.instance.currentUser;
    postData['creator'] = user!.uid;

    await FirebaseFirestore.instance
        .collection('teams')
        .doc(teamID)
        .collection('posts')
        .add(postData);
  }

Stream<QuerySnapshot<Map<String, dynamic>>> getPostForCurrentTeam(String teamID) {
  return FirebaseFirestore.instance
      .collection('teams')
      .doc(teamID)
      .collection('posts')
      .withConverter<Map<String, dynamic>>(
        fromFirestore: (snapshot, _) {
          final postData = snapshot.data()!;
          final creatorID = postData['creator'];
          final creatorRef = FirebaseFirestore.instance.collection('users').doc(creatorID);
          final creatorData = creatorRef.get().then((doc) => doc.data() as Map<String, dynamic>?);
          return postData..addAll({'creatorData': creatorData});
        },
        toFirestore: (data, _) => data,
      )
      .snapshots();
}


}

