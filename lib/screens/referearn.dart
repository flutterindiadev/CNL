import 'dart:convert';

import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/referal_model.dart';
import 'person_history.dart';
import 'package:share/share.dart';

class referearn extends StatefulWidget {
  const referearn({Key? key}) : super(key: key);

  static const routename = '/referearn';

  @override
  _referearnState createState() => _referearnState();
}

class _referearnState extends State<referearn> {
  // String id = '';
  bool isLoading = false;
  // String mobile = '';
  List<Referal> referalHistory = [];
  // String token = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadReferralData();
  }

  Future loadReferralData() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    http.post(Uri.parse(Appurl.referalDetails), body: {
      'coinlee_user_id': userData.user.userId,
      'token': userData.user.token,
    }).then((response) {
      if (json.decode(response.body)['status'] == true) {
        final parsedJson = json.decode(response.body)['result'] as List;
        final history = parsedJson.map((h) => Referal.fromJson(h)).toList();
        setState(() {
          referalHistory = history;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  share(mobile) async {
    Share.share(
      "I am using coinlee exchange App and I Love it!! It helps crypto investors find expert traders and let them manage their cryptocurrency, you can use my referral Code (${mobile.toString()}) to get exciting discount on account opening!! \n \n Referral code : ${mobile.toString()} \n \n Download this App Now! http://coinlee.live/r.php?me=${mobile.toString()}",
      subject: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            height: 70,
            width: 100,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10),
              child: OutlinedButton(
                  onPressed: () {
                    share(userData.user.userMobile);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    side: BorderSide(
                      width: 2.0,
                      color: Color(0xff1A22FF),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      Icon(Icons.people_alt_outlined),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Invite to Friends"),
                      ),
                    ],
                  )),
            ),
          ),
        ),
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
                child: Text('Checking Refferrals Data...'),
              )
            : referalHistory.isEmpty
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('You have 0 referrals',
                        style: TextStyle(fontSize: 15)),
                  ))
                : ListView.builder(
                    itemCount: referalHistory.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    personhistory.routename,
                                    arguments: referalHistory[index].userId);
                              },
                              child: Card(
                                elevation: 5,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                              "Name : ${referalHistory[index].firstName}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                              "Email : ${referalHistory[index].referEmail}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                              "Mobile : ${referalHistory[index].referMobile}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Referral CNL : ${num.parse(referalHistory[index].totalCoinsReceivedbyReferer).toStringAsFixed(1)}",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              Text(
                                                  "CNL purchased by referral : ${num.parse(referalHistory[index].totalCoinPurchase).toStringAsFixed(1)}",
                                                  style:
                                                      TextStyle(fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Recurring Monthly Income : ${num.parse(referalHistory[index].intrestCoinsAgainstHolding).toStringAsFixed(1)}",
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              // Text("Last Update: 30-05-2020 ",
                                              //     style: TextStyle(fontSize: 12)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
      ),
    );
  }
}
