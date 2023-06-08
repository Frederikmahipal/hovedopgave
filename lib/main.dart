import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hovedopgave_app/view-prelogin/login_screen.dart';
import 'package:hovedopgave_app/view/homepage.dart';
import 'package:hovedopgave_app/widgets/navbar.dart';
import 'package:hovedopgave_app/view/chatpage.dart';
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return MaterialApp(
            title: 'Hovedopgave - 2023',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: user == null
                ? LoginScreen()
                : Scaffold(
                    body: _buildBody(),
                    bottomNavigationBar: CustomNavBar(
                      currentIndex: _currentIndex,
                      onTap: onTabTapped,
                      user: user,
                    ),
                  ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return ProfilePage(userId: _user!.uid);
      case 2:
        return SettingsPage();
      default:
        return HomePage();
    }
  }
}
