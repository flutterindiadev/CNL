import 'dart:math';

import '../helpers/auth_provider.dart';

import '../helpers/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:platform_device_id/platform_device_id.dart';

import 'dashboard_screen.dart';

class OtpScreen extends StatefulWidget {
  static const routename = '/otp-screen';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isValid = false;
  int otp = 0;
  String otpText = '00000';
  Random random = Random();
  String userStatus = '';

  String? _deviceId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String? deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }
    if (!mounted) return;
    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context);
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int receivedOtp = routeArgs['otp'];
    String userMobile = routeArgs['Mobile'];
    print(receivedOtp);

    Future _navigate() async {
      setState(() {
        isLoading = true;
      });
      if (int.parse(otpText) == receivedOtp) {
        try {
          await user.loginWithOTP(userMobile, _deviceId!).then((_) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pushReplacementNamed(
                DashboardScreen.routename,
                arguments: userStatus);
          });
        } catch (e) {
          print(e);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Incorrect OTP'), backgroundColor: Colors.red));
      }
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Enter OTP',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Please enter the OTP sent on $userMobile',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 5,
                  onCompleted: (v) {},
                  onChanged: (value) {
                    setState(() {
                      otpText = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: Colors.blue,
                      inactiveColor: const Color(0xff707070),
                      activeFillColor: Colors.blue,
                      selectedFillColor: Colors.blue),
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  int otp = random.nextInt(88888) + 11111;
                  verifyMobile(userMobile, otp.toString());
                  setState(() {
                    receivedOtp = otp;
                  });
                },
                child: const Text('Resend OTP')),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                _navigate();
              },
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Image.asset(
                      'assets/images/loginbutton.png',
                      height: 50,
                      width: 50,
                    ),
            ),
            const Text(
              'Login',
            ),
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/images/screen1.png',
              height: MediaQuery.of(context).size.height / 3,
            )
          ],
        ),
      ),
    ));
  }
}
