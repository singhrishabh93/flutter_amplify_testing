import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Text(
          "Token: $token",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
