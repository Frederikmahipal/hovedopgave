import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovedopgave_app/view-prelogin/login_screen.dart';
import 'package:hovedopgave_app/view/homepage.dart';
import 'package:hovedopgave_app/reusable-widgets/navbar.dart';
import 'package:hovedopgave_app/view/profilepage.dart';
import 'package:hovedopgave_app/view/settingspage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user;

  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePage(),
    ProfilePage(),
    settingsPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
      print(_user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hovedopgave - 2023',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _user == null
          ? LoginPage()
          : Scaffold(
              body: _children[_currentIndex],
              bottomNavigationBar: CustomNavBar(
                currentIndex: _currentIndex,
                onTap: onTabTapped,
                user: _user,
              ),
            ),
    );
  }
}
