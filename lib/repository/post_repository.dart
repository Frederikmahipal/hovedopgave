import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPosts(String teamId) {
    if (teamId == null || teamId.isEmpty) {
      return Stream.empty();
    }
    final postsCollection = _firestore
        .collection('teams')
        .doc(teamId)
        .collection('posts');
    final snapshots = postsCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
    return snapshots;
  }

  Future<void> addPost(String teamId, String message) async {
    if (teamId == null || teamId.isEmpty) {
      return;
    }
    final postsCollection = _firestore
        .collection('teams')
        .doc(teamId)
        .collection('posts');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final postData = {'message': message, 'timestamp': timestamp};
    await postsCollection.add(postData);
  }
}
