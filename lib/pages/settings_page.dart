import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Center(
        child: Text(
          "Settings",
          style: TextStyle(fontSize: 32, color: Colors.black),
        ),
      ),
    );
  }
}
