import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(String uid, String name, String email) async {
    await userCollection.doc(uid).set({
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
}

  
