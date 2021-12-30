import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '../constants/appurl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'signup_screen.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoading = false;
  String mobileNumber = '';
  int otp = 0;
  Random random = Random();

  final _mobileNumberController = TextEditingController();

  void _generateOtp() {
    if (_mobileNumberController.text == '9999999999') {
      otp = 12345;
      setState(() {
        otp;
      });
    } else {
      int newotp = random.nextInt(88888) + 11111;
      setState(() {
        otp = newotp;
      });
    }
  }

  Future<void> _signIn() async {
    if (_mobileNumberController.text.isNotEmpty &&
        _mobileNumberController.text.length == 10) {
      isLoading = true;
      _generateOtp();
      http.post(Uri.parse(Appurl.verifyMobile), body: {
        'userMobile': _mobileNumberController.text,
        'otp': otp.toString(),
      }).then((response) {
        if (response.statusCode == 200) {
          if (json.decode(response.body)['status'] == true) {
            isLoading = false;
            Navigator.of(context).popAndPushNamed(OtpScreen.routename,
                arguments: {
                  'otp': otp,
                  'Mobile': _mobileNumberController.text
                });
          } else {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('User not found ! Please signup'),
              backgroundColor: Colors.red,
            ));
          }
        }
      });
    } else {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid mobile number')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // color: Colors.white,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/baground.jpeg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/images/cnlogo.png",
                scale: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                  controller: _mobileNumberController,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefix: const Text(
                        '+91',
                        style: TextStyle(fontSize: 20),
                      ),
                      label: const Text(
                        'Enter your Mobile Number',
                        style: TextStyle(fontSize: 15),
                      ),
                      hintText: 'Enter your mobile number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _signIn,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Image.asset(
                        'assets/images/forward.png',
                        height: 50,
                        width: 50,
                      ),
              ),
              const SizedBox(height: 10),
              const Text('or',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(SignUpScreen.routename);
                },
                child: const Text('Sign Up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/screen1.png',
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
