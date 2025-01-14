import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController tokenController = TextEditingController();
  String validationMessage = "";
  Color messageColor = Colors.black;

  @override
  void initState() {
    super.initState();
    tokenController.text = widget.token; // Pre-fill the token in the input field
  }

  Future<void> checkTokenValidity() async {
    const String url = "https://cxd1fke4p7.execute-api.us-east-1.amazonaws.com/dev/auth/validate";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${tokenController.text}",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["message"] == "Token is valid") {
          setState(() {
            validationMessage = "Valid Token";
            messageColor = Colors.green;
          });
        } else {
          setState(() {
            validationMessage = "Invalid Token";
            messageColor = Colors.red;
          });
        }
      } else {
        setState(() {
          validationMessage = "Invalid Token";
          messageColor = Colors.red;
        });
      }
    } catch (e) {
      setState(() {
        validationMessage = "Error checking token";
        messageColor = Colors.red;
      });
    }
  }

  // Refresh button function to reset the token to the original value
  void refreshToken() {
    setState(() {
      tokenController.text = widget.token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Token:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.token,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Modify Token for Validation:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: tokenController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter token here",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkTokenValidity,
              child: const Text("Check Token Validity"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: refreshToken, // Refresh button functionality
              child: const Text("Refresh Token"),
            ),
            const SizedBox(height: 20),
            Text(
              validationMessage,
              style: TextStyle(fontSize: 18, color: messageColor),
            ),
          ],
        ),
      ),
    );
  }
}
