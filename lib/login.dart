import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_amplify_testing/otp.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  Map<String, dynamic>? jsonData;

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    try {
      final String jsonString =
          await rootBundle.loadString("assets/login.json");
      setState(() {
        jsonData = jsonDecode(jsonString);
      });
    } catch (e) {
      print("Error loading JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image loaded from JSON
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
              // Phone number input
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const Text("|", style: TextStyle(fontSize: 33, color: Colors.grey)),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Button loaded from JSON
              if (jsonData != null && jsonData!["button"] != null)
                Padding(
                  padding: EdgeInsets.only(top: jsonData!["button"]["margin"]["top"], bottom: jsonData!["button"]["margin"]["bottom"]),
                  child: SizedBox(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyVerify()),
                        );
                      },
                      child: Text(jsonData!["button"]["text"]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
