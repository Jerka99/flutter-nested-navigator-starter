import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final String? string;
  final Function onPressed;

  const LoginPage({super.key, required this.onPressed, required this.string});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Page", style: TextStyle(fontSize: 32)),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(
                //   context,
                //   rootNavigator: false,
                // ).pushNamed("/page2");
                onPressed();
              },
              child: const Text("Go to /page2"),
            ),
          ],
        ),
      ),
    );
  }
}
