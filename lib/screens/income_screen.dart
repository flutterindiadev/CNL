//this is income details screen

import 'dart:convert';

import 'package:coinlee/constants/appurl.dart';
import 'package:coinlee/helpers/auth_provider.dart';
import 'package:coinlee/screens/history_page.dart';
import 'package:coinlee/screens/referearn.dart';
import 'package:coinlee/screens/staking_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  static const routename = 'income';

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  String usercount = '0';
  String totalcoins = '0';
  String stakeIncome = '0';
  String clubIncome = '0';
  bool isLoading = true;
  String sponsorIncome = '0';

  Future loadRefCount() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
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
        setState(() {
          usercount;
          totalcoins;
          stakeIncome;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future getSponsorIncome() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
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
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      loadRefCount();
      getSponsorIncome();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
            ),
          ),
          title: const Text('Income Details'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: isLoading
            ? Center(
                child: Text('Fetching Data...'),
              )
            : Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(referearn.routename);
                          },
                          child: Card(
                            elevation: 5,
                            child: Center(
                              child: Text(
                                'Referal Income : ${totalcoins}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(StakeDetailsScreen.routename);
                          },
                          child: Card(
                              elevation: 5,
                              child: Center(
                                child: Text('Staking Income : ${stakeIncome}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Card(
                          elevation: 5,
                          child: Center(
                            child: Text(
                                'Sponsor Stake Income : ${sponsorIncome}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
