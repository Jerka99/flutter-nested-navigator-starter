import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final Function() onPressed;

  const DetailsPage({super.key, required this.onPressed});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyan,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text("details")),
            TextButton(
              onPressed: () {
                widget.onPressed();
              },
              child: Text("smh"),
            ),
          ],
        ),
      ),
    );
  }
}
