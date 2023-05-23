import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPosts(String teamId) {
    if (teamId == null || teamId.isEmpty) {
      return Stream.empty();
    }
    final postsCollection =
        _firestore.collection('teams').doc(teamId).collection('posts');
    final snapshots =
        postsCollection.orderBy('timestamp', descending: true).snapshots();
    return snapshots;
  }


  Future<void> createPost(String teamId, String message) async {
    final postsCollection = _firestore.collection('teams').doc(teamId);

    await postsCollection.update({'created': FieldValue.serverTimestamp()});
    await postsCollection.set({'message': message}, SetOptions(merge: true));
  }

  Future<void> addPost(String teamId, String message) async {
    final postsCollection =
        _firestore.collection('teams').doc(teamId).collection('posts');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final postData = {'message': message, 'timestamp': timestamp};
    await postsCollection.add(postData);
  }

}
