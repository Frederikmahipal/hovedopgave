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

  Future<void> addComment(String teamID, String postID, Map<String, dynamic> commentData, String creatorName) async {
  final postRef = FirebaseFirestore.instance.collection('teams/$teamID/posts').doc(postID);
  final commentRef = postRef.collection('comments').doc();
  final commentID = commentRef.id;
  final commentWithID = {...commentData, 'id': commentID, 'user': creatorName, 'timestamp': FieldValue.serverTimestamp()};
  try {
    await commentRef.set(commentWithID);
    await postRef.update({'comments': FieldValue.arrayUnion([commentRef.id])});
  } catch (e) {
    print('Error adding comment: $e');
    rethrow;
  }
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsForPost(String teamID, String postID) {
    final postRef = FirebaseFirestore.instance
        .collection('teams')
        .doc(teamID)
        .collection('posts')
        .doc(postID);
    final commentsRef = postRef.collection('comments');
    return commentsRef.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> deleteCommentFromPost(String teamID, String postID, String commentID) async {
    await _firestore
        .collection('teams')
        .doc(teamID)
        .collection('posts')
        .doc(postID)
        .collection('comments')
        .doc(commentID)
        .delete();
  }
}
