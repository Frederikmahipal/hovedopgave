import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';


class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<dynamic, dynamic>;
    return User(
      name: data['name'],
      email: data['email'],
    );
  }
}

class MyFirestoreService {
  final String uid;

  MyFirestoreService({required this.uid});

  // Get user data from Firestore
  Stream<User> get userData {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => User.fromFirestore(doc));
  }
}