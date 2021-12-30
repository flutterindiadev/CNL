import '../helpers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routename = '/profile-screen';

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
            ),
          ),
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  width: 150.0,
                  height: 150.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/person.png')),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                userData.user.firstName + " " + userData.user.lastName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                'User Id : ${userData.user.userId}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Information :",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "First Name :",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          userData.user.firstName,
                          style: TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Last Name :",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        userData.user.lastName,
                        style: TextStyle(
                            fontSize: 14, decoration: TextDecoration.underline),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Email ID :",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        userData.user.userEmail,
                        style: TextStyle(
                            fontSize: 14, decoration: TextDecoration.underline),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Mobile NO :",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        userData.user.userMobile,
                        style: TextStyle(
                            fontSize: 14, decoration: TextDecoration.underline),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ]));
  }
}
