import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovedopgave_app/models/user.dart' as MyUser;

class UserRepository {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  static String? _selectedUserId;

  Future<void> createUser(String uid, String name, String email) async {
  await userCollection.doc(uid).set({
    'uid': uid,
    'name': name,
    'email': email,
  });
}


  Future<void> updateUser(String uid, String name, String email) async {
    await userCollection.doc(uid).update({
      'name': name,
      'email': email,
    });
  }

  Future<void> deleteUser(String uid) async {
    await userCollection.doc(uid).delete();
  }

  MyUser.User? getCurrentUser() {
    final userFromStore = _firebaseAuth.currentUser;
    if (userFromStore == null) {
      return null;
    }
    final user = new Map<String, dynamic>();
    user['uid'] = userFromStore.uid;
    user['email'] = userFromStore.email;
    user['name'] = userFromStore.displayName;
    return user != null ? MyUser.User.fromJson(user) : null;
  }

  Future<List<MyUser.User>> getAllUsers() async {
    final querySnapshot = await userCollection.get();
    final List<MyUser.User> users = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final user = MyUser.User.fromJson(data);
      users.add(user);
      print('UID: ${user.uid}');
    });
    return users;
  }

  Future<String> getUserNameById(String uid) async {
    final userDoc = await userCollection.doc(uid).get();
    final userData = userDoc.data() as Map<String, dynamic>?;
    if (userDoc.exists && userData != null && userData.containsKey('name')) {
      return userData['name'];
    } else {
      return '';
    }
  }

  String? getSelectedUserId() {
    return _selectedUserId;
  }

  void setSelectedUserId(String? userId) {
    _selectedUserId = userId;
  }
}
