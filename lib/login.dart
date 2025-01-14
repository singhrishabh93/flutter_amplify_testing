import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'otp.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  Map<String, dynamic>? jsonData;

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    try {
      final String jsonString = await rootBundle.loadString("assets/login.json");
      setState(() {
        jsonData = jsonDecode(jsonString);
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  Future<void> sendOTP() async {
    final String phoneNumber = "${countryController.text}${phoneController.text}";
    final String url =
        "https://3jhuhkyubc.execute-api.us-east-1.amazonaws.com/dev/otp/create?phoneNumber=$phoneNumber";
    try {
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);
      print("OTP Response: ${data['message']}");
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyVerify(phoneNumber: phoneNumber),
          ),
        );
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (jsonData != null && jsonData!["image"] != null)
                Image.asset(
                  jsonData!["image"]["src"],
                  width: (jsonData!["image"]["width"] as num).toDouble(),
                  height: (jsonData!["image"]["height"] as num).toDouble(),
                ),
              const SizedBox(height: 25),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        decoration: const InputDecoration(border: InputBorder.none),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Text("|", style: TextStyle(fontSize: 33, color: Colors.grey)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (jsonData != null && jsonData!["button"] != null)
                SizedBox(
                  width: (jsonData!["button"]["width"] as num).toDouble(),
                  height: (jsonData!["button"]["height"] as num).toDouble(),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse(jsonData!["button"]["backgroundColor"])),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          (jsonData!["button"]["borderRadius"] as num).toDouble(),
                        ),
                      ),
                    ),
                    onPressed: sendOTP,
                    child: Text(jsonData!["button"]["text"]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
