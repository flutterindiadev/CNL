import 'dart:convert';

import 'package:flutter/material.dart';
import '../constants/mybutton.dart';

import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routename = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    String firstName = '';
    String lastName = '';
    String mobileNumber = '';
    String email = '';
    String referalCode = '';
    bool isLoading = false;

    const url =
        'https://developer.satmatgroup.com/coinlee/Applogin/registerUserDetails';

    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _mobileNumberController = TextEditingController();
    final _emailController = TextEditingController();
    // final _passwordController = TextEditingController();
    final _reEnterPasswordController = TextEditingController();
    final _referalCodeController = TextEditingController();
    final _form = GlobalKey<FormState>();

    @override
    void dispose() {
      _firstNameController.dispose();
      _lastNameController.dispose();
      _mobileNumberController.dispose();
      _emailController.dispose();
      // _passwordController.dispose();
      _reEnterPasswordController.dispose();
      _referalCodeController.dispose();
      super.dispose();
    }

    Future<void> _saveForm() async {
      setState(() {
        isLoading = true;
      });
      _form.currentState!.save();
      final json = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'mobileNumber': _mobileNumberController.text,
        // 'password': _passwordController.text,
        'referalBy': _referalCodeController.text,
        'email': _emailController.text,
      };
      return http.post(Uri.parse(url), body: json).then((response) {
        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['status'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('SignUp succesful'),
              duration: Duration(seconds: 2),
            ));
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Something went wrong'),
              duration: Duration(seconds: 2),
            ));
            setState(() {
              isLoading = false;
            });
          }
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/baground.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/cnlogo.png",
                    scale: 3,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('First Name'),
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.person,
                                ),
                              ),
                              hintText: 'Enter your first name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            controller: _firstNameController,
                            onSaved: (val) {
                              firstName = val!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                label: const Text('Last Name'),
                                prefix: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.person,
                                  ),
                                ),
                                hintText: 'Enter your last name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              textInputAction: TextInputAction.next,
                              controller: _lastNameController,
                              onSaved: (val) {
                                lastName = val!;
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('Mobile Number'),
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.mobile_screen_share_outlined,
                                ),
                              ),
                              hintText: 'Enter your mobile number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            controller: _mobileNumberController,
                            onSaved: (val) {
                              mobileNumber = val!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('Email address'),
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.mark_email_read_rounded,
                                ),
                              ),
                              hintText: 'Enter your email address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            controller: _emailController,
                            onSaved: (val) {
                              email = val!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              label: const Text('Referral Code'),
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.people_alt_rounded,
                                ),
                              ),
                              hintText: 'Enter referral code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            controller: _referalCodeController,
                            onSaved: (val) {
                              referalCode = val!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                      onTap: _saveForm,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : MyButton(
                              text: "SignUp",
                            )),
                  // const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
