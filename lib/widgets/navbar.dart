import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final User? user;

  CustomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.user,
  });

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Hold',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_rounded),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Indstillinger',
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant CustomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.user != oldWidget.user) {
      setState(() {});
    }
  }
}
