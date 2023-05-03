import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String name;
  final String email;

  Users({
    required this.name,
    required this.email,
  });
}
