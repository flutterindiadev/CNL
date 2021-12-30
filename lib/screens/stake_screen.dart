import '../helpers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../constants/mybutton.dart';
import 'package:flutter/material.dart';

import 'plan_details.dart';

class StakeScreen extends StatelessWidget {
  static const routename = '/stake-screen';

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 60),
            child: GestureDetector(
                child: MyButton(text: 'Stake Coinlee'),
                onTap: () {
                  Navigator.of(context).pushNamed(plandetails.routename);
                })),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1A22FF), Color(0xff0D1180)],
              ),
            ),
          ),
          title: const Text('Coinlee'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPaint(
              child: Container(),
              painter: HeaderCurvedContainer(),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Image.asset(
                                          "assets/images/StackScreen.png",
                                          scale: 4,
                                        ),
                                      ),
                                      Text(
                                        userData.user.holdingCoins,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      "Stake Coin",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: Image.asset(
                                          "assets/images/stackCoins.png",
                                          scale: 4,
                                        ),
                                      ),
                                      Text(
                                        userData.user.availableCoins,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      "Available Coin",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How does staking work?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "1. Staking is the process of actively participating in transaction validation (similar to mining) on a proof-of-stake blockchain.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "2. If the cryptocurrency you're storing is eligible for rewards (staking rewards, etc.), you'll receive rewards for that crypto..",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "3. Terms and Conditions for staking on Coinlee",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff1A22FF);
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 150.0, size.width, 100)
      ..relativeLineTo(0, -100)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
