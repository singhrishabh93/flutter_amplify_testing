import 'package:flutter/material.dart';
import 'package:flutter_amplify_testing/home.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MyVerify extends StatefulWidget {
  final String phoneNumber;

  const MyVerify({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  Map<String, dynamic>? jsonData;
  String otp = ""; // To store the entered OTP

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    try {
      final String jsonString = await rootBundle.loadString("assets/otp.json");
      setState(() {
        jsonData = jsonDecode(jsonString);
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

 Future<void> verifyOTP() async {
  final String url =
      "https://3jhuhkyubc.execute-api.us-east-1.amazonaws.com/dev/otp/verify?phoneNumber=${widget.phoneNumber}&otp=$otp";

  try {
    final response = await http.post(Uri.parse(url));
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["token"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Verified Successfully!")),
        );
        // Navigate directly to HomePage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: data['token']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${data['message']}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification failed: ${response.body}")),
      );
    }
  } catch (e) {
    print("Error verifying OTP: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("An error occurred. Please try again.")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    // Default Pin Theme
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(234, 239, 243, 1),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (jsonData != null && jsonData!["image"] != null)
                Image.asset(
                  jsonData!["image"]["src"],
                  width: (jsonData!["image"]["width"] as num).toDouble(),
                  height: (jsonData!["image"]["height"] as num).toDouble(),
                ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              if (jsonData != null && jsonData!["otpInput"] != null)
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  showCursor: jsonData!["otpInput"]["showCursor"] ?? true,
                  onCompleted: (pin) {
                    setState(() {
                      otp = pin; // Store the entered OTP
                    });
                  },
                ),
              const SizedBox(
                height: 20,
              ),
              if (jsonData != null && jsonData!["button"] != null)
                SizedBox(
                  width: (jsonData!["button"]["width"] as num).toDouble(),
                  height: (jsonData!["button"]["height"] as num).toDouble(),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse(
                          jsonData!["button"]["backgroundColor"])),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          (jsonData!["button"]["borderRadius"] as num).toDouble(),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (otp.isNotEmpty) {
                        verifyOTP();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter the OTP.")),
                        );
                      }
                    },
                    child: Text(jsonData!["button"]["text"]),
                  ),
                ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'phone',
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Edit Phone Number?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
