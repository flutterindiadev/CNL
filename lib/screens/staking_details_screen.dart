import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:coinlee/constants/appurl.dart';
import 'package:coinlee/helpers/auth_provider.dart';

class StakeDetailsScreen extends StatefulWidget {
  const StakeDetailsScreen({Key? key}) : super(key: key);

  static const routename = '/income-details';

  @override
  State<StakeDetailsScreen> createState() => _StakeDetailsScreenState();
}

class _StakeDetailsScreenState extends State<StakeDetailsScreen> {
  List<StakeIncomeDetail> incomeDetails = [];
  bool isLoading = true;
  Future getUserStakingIncome() async {
    final user = Provider.of<AuthProvider>(context, listen: false);

    final response =
        await http.post(Uri.parse(Appurl.getUserStakingIncome), body: {
      'coinlee_user_mobile': user.user.userMobile,
      'coinlee_user_id': user.user.userId,
      'token': user.user.token
    });
    if (json.decode(response.body)['status'] == true) {
      final parsedJson = json.decode(response.body)['wallet_balance'];
      for (var i = 0; i < parsedJson.length; i++) {
        if (parsedJson[i]['stake_income'] != '0') {
          incomeDetails.add(StakeIncomeDetail(
              transactionDate: parsedJson[i]['transaction_date'],
              stake_income: parsedJson[i]['stake_income'],
              plan: parsedJson[i]['plan_name'],
              coinlee_coins_hold_id: parsedJson[i]['coinlee_coins_hold_id']));
        }
      }
      if (this.mounted) {
        setState(() {
          incomeDetails;
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
  }

  @override
  void initState() {
    getUserStakingIncome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
          ),
        ),
        title: Text('Staking Income Details'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: Text('Receiving transaction Details...'),
            )
          : ListView.builder(
              itemCount: incomeDetails.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction Id : ${incomeDetails[index].coinlee_coins_hold_id}',
                            style: TextStyle(fontSize: 12),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              color: Colors.black54,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Stake start Date :',
                                  style: TextStyle(fontSize: 12)),
                              Text(
                                  '${(incomeDetails[index].transactionDate).split(" ")[0]}',
                                  style: TextStyle(fontSize: 12))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Stake Duration :',
                                  style: TextStyle(fontSize: 12)),
                              Text(incomeDetails[index].plan,
                                  style: TextStyle(fontSize: 12))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Income :', style: TextStyle(fontSize: 12)),
                              Text(incomeDetails[index].stake_income,
                                  style: TextStyle(fontSize: 12))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class StakeIncomeDetail {
  String stake_income;
  String transactionDate;
  String coinlee_coins_hold_id;
  String plan;
  StakeIncomeDetail({
    required this.stake_income,
    required this.transactionDate,
    required this.coinlee_coins_hold_id,
    required this.plan,
  });
}
