import 'usdt_payment_screen.dart';

import '../constants/mybutton.dart';
import 'usdt_payment_screen.dart';
import 'package:flutter/material.dart';

class RoutePaymentScreen extends StatelessWidget {
  const RoutePaymentScreen({Key? key}) : super(key: key);

  static const routename = 'route-payment';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String amount = routeArgs['amount'];
    String result = routeArgs['result'];

    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1A22FF), Color(0xff0D1180)],
              ),
            ),
          ),
          title: Text('Select Payment method')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              child: MyButton(text: 'Crypto'),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(UsdtPaymentScreen.routename, arguments: amount);
              },
            ),
          ],
        ),
      ),
    );
  }
}
