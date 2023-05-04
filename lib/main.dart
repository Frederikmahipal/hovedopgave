import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hovedopgave_app/view-prelogin/login_screen.dart';
import 'package:hovedopgave_app/view-prelogin/signup_screen.dart';
import 'package:hovedopgave_app/view/homepage.dart';
import 'package:hovedopgave_app/reusable-widgets/navbar.dart';
import 'package:hovedopgave_app/view/profilepage.dart';
import 'package:hovedopgave_app/view/settingspage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

 final List<Widget> _children = [HomePage(), ProfilePage(), settingsPage()]; // ADD MORE PAGES HGERE];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
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
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: CustomNavBar(currentIndex: _currentIndex, onTap: onTabTapped),
      ),
    );
  }
}
