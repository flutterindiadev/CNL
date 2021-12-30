import 'dart:convert';
import 'dart:math';

import '../constants/appurl.dart';
import '../constants/mybutton.dart';
import '../helpers/auth_provider.dart';
import 'animation.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class plandetails extends StatefulWidget {
  const plandetails({Key? key}) : super(key: key);

  static const routename = 'plan-details';

  @override
  _plandetailsState createState() => _plandetailsState();
}

class _plandetailsState extends State<plandetails> {
  // var Umobile = '';
  // var cUserId = '';
  var dataLength;
  var interest = [];
  bool isLoading = true;
  late int max;
  int min = 1;
  var monthlyPlanID;
  var noOfMonths = [];
  var planId = [];
  TextEditingController stackCoin = TextEditingController();
  // var token = '';
  // var userID = '';
  int value = 0;

  late ConfettiController _controllerTopCenter;

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    planDetails();
    super.initState();
  }

  planDetails() async {
    final userToken =
        Provider.of<AuthProvider>(context, listen: false).user.token;
    final body = {
      'token': userToken,
    };
    Response response = await post(
      Uri.parse(Appurl.plandetails),
      body: body,
    );
    String responseBody = response.body;
    if (response.statusCode == 200) {
      setState(() {
        //
        debugPrint(responseBody);
        var data = json.decode(responseBody);
        int j = 0;
        dataLength = data["result"].length;
        noOfMonths.clear();
        interest.clear();
        var result = [];
        var result1 = [];
        var result3 = [];
        for (int i = 0; i < data["result"].length; i++) {
          // result.add(data["result"][i]["plan_name"]);
          result1.add(data["result"][i]["no_of_months"]);
          result.add(data["result"][i]["intrest_rate"]);
          result3.add(data["result"][i]["plan_id"]);
        }
        interest = result1;
        noOfMonths = result;
        planId = result3;
      });
      isLoading = false;
    }
    print(noOfMonths);
    print(interest);
  }

  Widget buildButton(
      {VoidCallback? onTap, required String text, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: MaterialButton(
        color: color,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);

    stackCoins() async {
      setState(() {
        isLoading = true;
      });
      if (stackCoin.text.isNotEmpty) {
        if (num.parse(stackCoin.text) >= min &&
            num.parse(stackCoin.text) <=
                num.parse(userData.user.availableCoins)) {
          final body = {
            'coinlee_user_id': userData.user.userId,
            'userMobile': userData.user.userMobile,
            'no_of_coins': stackCoin.text,
            'plan_id': monthlyPlanID ?? planId[0],
            'token': userData.user.token,
          };
          Response response =
              await post(Uri.parse(Appurl.stakecoins), body: body);
          String responseBody = response.body;
          if (response.statusCode == 200) {
            var data = json.decode(responseBody);
            Navigator.of(context)
                .pushReplacementNamed(StakeSuccess.routename, arguments: {
              'numberOfCoins': data["result"]["no_of_coins"],
              'order_id': data["result"]["order_id"],
              'intrest_rate': data["result"]["intrest_rate"],
              'maturity_date': data["result"]["maturity_date"]
            });
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Please enter a valid amount'),
            backgroundColor: Colors.red));
        setState(() {
          isLoading = false;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 60),
            child: GestureDetector(
                onTap: stackCoins,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MyButton(
                        text: 'Confirm Stake',
                      ))),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1A22FF), Color(0xff0D1180)],
              ),
            ),
          ),
          title: const Text('Coinlee'),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: SizedBox(
                    child: const CircularProgressIndicator(
                strokeWidth: 2.5,
              )))
            : Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Enter Amount Coinlee",
                              style: TextStyle(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 110),
                              child: TextFormField(
                                onChanged: (String value) {
                                  int x;
                                  max = int.parse(userData.user.availableCoins);
                                  try {
                                    x = int.parse(value);
                                  } catch (error) {
                                    x = min;
                                  }
                                  if (x < min) {
                                    x = min;
                                  } else if (x > max) {
                                    x = max;
                                  }

                                  stackCoin.value = TextEditingValue(
                                    text: x.toString(),
                                    selection: TextSelection.fromPosition(
                                      TextPosition(
                                          offset: stackCoin
                                              .value.selection.baseOffset),
                                    ),
                                  );
                                },
                                controller: stackCoin,
                                decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 30.0, horizontal: 31.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    labelStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    // labelText: 'Password',
                                    hintText: "0",
                                    hintStyle: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            // ToDo:
                            Text(
                              "Available Coin : ${userData.user.availableCoins}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                "Staking Options :",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            ListView.builder(
                                itemCount: dataLength,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          interest[index]
                                                              .toString(),
                                                          // "12",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: const Text(
                                                            "Months",
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  noOfMonths[index]
                                                                          .toString() +
                                                                      " %",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      const Text(
                                                                    "Return/ Month",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: RadioListTile<int>(
                                                        value: index,
                                                        groupValue: value,
                                                        onChanged: (ind) =>
                                                            setState(() {
                                                              value = ind!;
                                                              debugPrint(planId[
                                                                      index]
                                                                  .toString());
                                                              monthlyPlanID =
                                                                  planId[index];
                                                            })),
                                                    // title: Text("Number $index"),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _controllerTopCenter,
                      blastDirection: pi / 1,
                      // blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      emissionFrequency: 0.1,
                      canvas: Size.fromRadius(
                          MediaQuery.of(context).size.height * .35),
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _controllerTopCenter,
                      blastDirection: pi / 4,
                      // blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      emissionFrequency: 0.1,
                      canvas: Size.fromRadius(
                          MediaQuery.of(context).size.height * .35),
                      colors: const [
                        Colors.green,
                        Colors.blue,
                        Colors.pink,
                        Colors.orange,
                        Colors.purple
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
