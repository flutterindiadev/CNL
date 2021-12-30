import 'dart:async';
import 'dart:convert';

import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../helpers/session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ledgerReport extends StatefulWidget {
  const ledgerReport({Key? key}) : super(key: key);

  static const routename = '/ledger-Report';

  @override
  _ledgerReportState createState() => _ledgerReportState();
}

class _ledgerReportState extends State<ledgerReport> {
  List coinclosing = [];
  List coincredit = [];
  List coindebit = [];
  var coinleeUser = '';
  var coinleeUserId = '';
  List coinopening = [];
  var dataLength;
  bool isLoading = true;
  var nodatafound = '';
  List orderId = [];
  var token = '';
  List transitionType = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getledgerreport();
  }

  getledgerreport() async {
    final userData = Provider.of<AuthProvider>(context);
    final body = {
      'token': userData.user.token,
      'coinlee_user_id': userData.user.userId
    };
    Response response = await post(Uri.parse(Appurl.getLedger), body: body);
    String responseBody = response.body;
    if (response.statusCode == 200) {
      setState(() {
        var data = json.decode(responseBody);

        if (data["message"] == "No data found.") {
          nodatafound = "1";

          isLoading = false;
        } else {
          nodatafound = '2';
          dataLength = data["result"].length;
          List result = [];
          List result1 = [];
          List result3 = [];
          List result4 = [];
          List result5 = [];
          List result6 = [];
          for (int i = 0; i < data["result"].length; i++) {
            result4.add(data["result"][i]["coin_closing"]);
            result1.add(data["result"][i]["coin_opening"]);
            result.add(data["result"][i]["coin_debit"]);
            result3.add(data["result"][i]["coin_credit"]);
            result5.add(data["result"][i]["user_coin_wallet_id"]);
            result6.add(data["result"][i]["txn_type"]);
          }
          coinopening = result1;
          coindebit = result;
          coincredit = result3;
          coinclosing = result4;
          orderId = result5;
          transitionType = result6;
          isLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
            ),
          ),
          title: const Text('Ledger Report'),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : nodatafound == "1"
                ? Center(child: Text("No Data Found"))
                : Column(
                    children: [
                      CustomPaint(
                        child: Container(),
                        painter: HeaderCurvedContainer(),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.84,
                        width: double.infinity,
                        child: ListView.builder(
                          reverse: true,
                          itemCount: dataLength,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 5),
                                              child: Text(
                                                  "Order ID : ${orderId[index]}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Text("View Details",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      decoration: TextDecoration
                                                          .underline)),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Transaction Type",
                                                  style:
                                                      TextStyle(fontSize: 11)),
                                              Text("credit /debit",
                                                  style:
                                                      TextStyle(fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Upi Id",
                                                  style:
                                                      TextStyle(fontSize: 11)),
                                              Text(transitionType[index],
                                                  style:
                                                      TextStyle(fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.blue,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Text("Opening Coins",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white)),
                                              )),
                                              Expanded(
                                                  child: Text("Coins Credited",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.white))),
                                              Expanded(
                                                  child: Text("Coins Debited",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.white))),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                  child: Text("Closing Coins",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.white))),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Text(coinopening[index],
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              )),
                                              Expanded(
                                                  child: Text(coincredit[index],
                                                      style: TextStyle(
                                                          fontSize: 12))),
                                              Expanded(
                                                  child: Text(coindebit[index],
                                                      style: TextStyle(
                                                          fontSize: 12))),
                                              Expanded(
                                                  child: Text(
                                                      coinclosing[index],
                                                      style: TextStyle(
                                                          fontSize: 12))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
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
      ..relativeLineTo(0, 120)
      ..quadraticBezierTo(size.width / 2, 200.0, size.width, 120)
      ..relativeLineTo(0, -120)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
