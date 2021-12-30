import 'dart:convert';
import 'package:coinlee/screens/staking_details_screen.dart';

import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'referearn.dart';

class IncomeHistoryScreen extends StatefulWidget {
  const IncomeHistoryScreen({Key? key}) : super(key: key);

  static const routename = '/income-history-screen';

  @override
  State<IncomeHistoryScreen> createState() => _IncomeHistoryScreenState();
}

class _IncomeHistoryScreenState extends State<IncomeHistoryScreen> {
  String coinleeUserId = '';
  bool isLoading = true;
  String refCount = '0';
  String token = '';
  String totalcoins = '0';
  String stakeIncome = '0';
  String totalearning = '0';
  String clubIncome = '0';
  String userId = '';
  String usercount = '0';
  String sponsorIncome = '0';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadRefCount();
    getSponsorIncome();
  }

  Future loadRefCount() async {
    final userData = Provider.of<AuthProvider>(context);
    http.post(Uri.parse(Appurl.getUserReferalCount), body: {
      'coinlee_user_id': userData.user.userId,
      'token': userData.user.token
    }).then((response) {
      if (json.decode(response.body)['status'] == true) {
        final parsedJson = json.decode(response.body)['result'] as List;
        usercount = parsedJson[0]['user_count'].toString();
        totalcoins = num.parse(parsedJson[0]['total_coin_earn'].toString())
            .toStringAsFixed(4);
        stakeIncome = num.parse(parsedJson[0]['staking_income'].toString())
            .toStringAsFixed(2);
        clubIncome = num.parse(parsedJson[0]['club_income'].toString())
            .toStringAsFixed(2);
        if (this.mounted) {
          setState(() {
            usercount;
            totalcoins;
            stakeIncome;
            isLoading = false;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Future getSponsorIncome() async {
    final userData = Provider.of<AuthProvider>(context);
    final response = await http.post(
        Uri.parse(
            'https://developer.satmatgroup.com/coinlee/appapi/getUserReferalStakeIntrestIncome'),
        body: {
          'coinlee_user_mobile': userData.user.userMobile,
          'coinlee_user_id': userData.user.userId,
          'token': userData.user.token
        });
    if (json.decode(response.body)['status'] == true) {
      final Income = json.decode(response.body)['wallet_balance'];
      if (this.mounted) {
        setState(() {
          sponsorIncome = Income;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
          ),
        ),
        title: const Text('Income History'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: isLoading
          ? const Center(
              child: Text(
              'Fetching Income History...',
              style: TextStyle(fontSize: 15),
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(referearn.routename);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              // side: const BorderSide(color: Colors.black45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Image.asset(
                                    "assets/images/stack.png",
                                    scale: 3,
                                  ),
                                ),
                                Text(
                                  'Total referrals : $usercount',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Referral CNL: $totalcoins',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(StakeDetailsScreen.routename);
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Image.asset(
                                        "assets/images/available.png",
                                        scale: 3,
                                      ),
                                    ),
                                    Text(
                                      'Staking Income : ${stakeIncome} CNL',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Image.asset(
                                      "assets/images/club.png",
                                      scale: 3,
                                    ),
                                  ),
                                  Text(
                                    'Sponsor Stake Income : ${sponsorIncome} ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
