import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  Map<String, dynamic>? jsonData;

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

  @override
  Widget build(BuildContext context) {
    // Default Pin Theme
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(234, 239, 243, 1),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    // Handle OTP input
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
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
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              if (jsonData != null && jsonData!["otpInput"] != null)
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  showCursor: jsonData!["otpInput"]["showCursor"] ?? true,
                  onCompleted: (pin) => print(pin),
                ),
              SizedBox(
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
                      // Button functionality (this can be navigational or any action)
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
                    child: Text(
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
