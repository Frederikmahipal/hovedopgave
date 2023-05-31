class User {
  final String uid;
  final String email;
  final String name;
  final bool isAdmin;

  User({required this.uid, required this.email, required this.name, required this.isAdmin});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'isAdmin': isAdmin,
    };
  }

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, name: $name, isAdmin: $isAdmin)';
  }
}
