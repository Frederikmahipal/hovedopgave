import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final _firestore = FirebaseFirestore.instance;


Future<void> createPost(String teamID, Map<String, dynamic> postData) async {
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
          fromFirestore: (snapshot, _) => snapshot.data()!,
          toFirestore: (data, _) => data)
      .snapshots();
}

}
