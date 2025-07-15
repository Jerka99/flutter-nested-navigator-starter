import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  final Function() onPressed;

  const ProfileWidget({required this.onPressed, super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              widget.onPressed();
            },
            child: Text("button"),
          ),
        ],
      ),
    );
  }
}
