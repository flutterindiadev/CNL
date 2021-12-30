import '../helpers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/mybutton.dart';
import 'route_payment_screen.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({Key? key}) : super(key: key);

  static const routename = '/buy-screen';

  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

@override
class _BuyScreenState extends State<BuyScreen> {
  String amount = '0';
  String result = '0';
  TextEditingController usdtAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);

    void finalCoinlee(String amount) {
      if (amount.isNotEmpty) {
        try {
          var finalresult = (double.tryParse(amount))! *
              num.parse(userData.user.usdRate) /
              num.parse(userData.user.cnlRate);
          print(finalresult);
          setState(() {
            result = finalresult.toStringAsFixed(2);
          });
        } catch (e) {
          print(e);
        }
      } else {
        return;
      }
    }

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
            ),
          ),
          title: const Text('Coinlee'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                CustomPaint(
                  child: Container(),
                  painter: HeaderCurvedContainer(),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'You will receive',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Text(result,
                    style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const Text('Coinlee', style: TextStyle(color: Colors.white70)),
                const SizedBox(
                  height: 50,
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 200),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: usdtAmount,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '\$ ',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (val) {
                      if (int.parse(val) >= 12) {
                        amount = val;
                        finalCoinlee(amount);
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Card(
                          // color: Color(0xFFD0E7FD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "1 Coinlee",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff1A22FF),
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    //Calculate dynamic CNL price
                                    '${(1 / (num.parse(userData.user.usdRate) / num.parse(userData.user.cnlRate))).toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Card(
                          // color: Color(0xFFD0E7FD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Transaction Fees",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff1A22FF),
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "3 USDT",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Card(
                          // color: Color(0xFFD0E7FD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Your amount",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff1A22FF),
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "$amount USDT",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Card(
                          // color: Color(0xFFD0E7FD),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "You will pay",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff1A22FF),
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${int.parse(amount) + 3} USDT",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                    width: 150,
                    child: GestureDetector(
                        child: MyButton(text: 'Buy Now'),
                        onTap: () {
                          if (int.parse(usdtAmount.text) >= 12) {
                            Navigator.of(context).pushNamed(
                                RoutePaymentScreen.routename,
                                arguments: {
                                  'amount': (int.parse(usdtAmount.text) + 3)
                                      .toString(),
                                  'result': result.toString()
                                });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Please Enter amount Greater than 12'),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }))
              ],
            ),
          ),
        ));
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff1A22FF);
    Path path = Path()
      ..relativeLineTo(0, 100)
      ..quadraticBezierTo(size.width / 2, 170.0, size.width, 100)
      ..relativeLineTo(0, -100)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
