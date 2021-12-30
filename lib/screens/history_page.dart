import 'dart:convert';

import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../models/history_model.dart';

//This is staking history page

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  static const routename = '/history-page';

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String coinHoldId = '';
  bool isLoading = false;
  List<HistoryData> transactionData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showHistory();
  }

  Future<void> showHistory() async {
    final userData = Provider.of<AuthProvider>(context);
    setState(() {
      isLoading = true;
    });
    final body = {
      'coinlee_user_id': userData.user.userId,
      'token': userData.user.token
    };
    Response response =
        await post(Uri.parse(Appurl.holdingDetails), body: body);
    String responseBody = response.body;
    if (response.statusCode == 200) {
      final parsedJsonResult = json.decode(responseBody)['result'] as List;
      if (json.decode(responseBody)['status'] == true) {
        final transanctions =
            parsedJsonResult.map((h) => HistoryData.fromJson(h)).toList();
        setState(() {
          transactionData = transanctions;
          isLoading = false;
        });
      }
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
          title: const Text('Staking History'),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: Text('Fetching Transactions...',
                    style: TextStyle(fontSize: 15)))
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    CustomPaint(
                      child: Container(),
                      painter: HeaderCurvedContainer(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    transactionData.isNotEmpty
                        ? Container(
                            height: MediaQuery.of(context).size.height - 170,
                            child: ListView.builder(
                              reverse: true,
                              itemCount: transactionData.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) {
                                coinHoldId = transactionData[i].transactionId;
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 5,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 25.0),
                                                      child: Text(
                                                          "Transaction ID : ${transactionData[i].transactionId}",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20.0),
                                                  child: Divider(
                                                    thickness: 1,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Column(
                                                    children: [
                                                      Row(
                                                        children: [],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Transaction Date :",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                          Text(
                                                              transactionData[i]
                                                                  .transactionDate
                                                                  .split(
                                                                      " ")[0],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Stake Maturity :",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                          Text(
                                                              transactionData[i]
                                                                  .maturityDate,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Coins :",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                          Text(
                                                              transactionData[i]
                                                                  .numberofCoins,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Text('No transactions found'),
                          ),
                  ]),
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
