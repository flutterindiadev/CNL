import 'dart:convert';

import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WelcomeBonusScreen extends StatefulWidget {
  const WelcomeBonusScreen({Key? key}) : super(key: key);

  static const routename = '/welcome-bonus';

  @override
  State<WelcomeBonusScreen> createState() => _WelcomeBonusScreenState();
}

class _WelcomeBonusScreenState extends State<WelcomeBonusScreen> {
  String bonus = '0';
  String bonusDate = 'Not Applicable';
  bool hasData = false;
  bool isLoading = true;
  bool multiJson = false;
  String sBonus = '0';
  String sBonusDate = 'Not Applicable';
  String sBonusUnlockDate = 'Not Applicable';
  String token = '';
  String unlockDate = 'Not applicable';
  String userId = '';
  String usercount = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      getBonus();
      loadRefCount();
    });
  }

  Future loadRefCount() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
    http.post(Uri.parse(Appurl.getUserReferalCount), body: {
      'coinlee_user_id': userData.user.userId,
      'token': userData.user.token,
    }).then((response) {
      if (json.decode(response.body)['status'] == true) {
        final parsedJson = json.decode(response.body)['result'] as List;
        usercount = parsedJson[0]['user_count'].toString();
        if (this.mounted) {
          setState(() {
            usercount;
            isLoading = false;
          });
        }
      }
    });
  }

  Future getBonus() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
    final response = await http.post(Uri.parse(Appurl.welcomeBonus), body: {
      'coinlee_user_id': userData.user.userId,
      'token': userData.user.token
    });
    final parsedBody = json.decode(response.body);
    print(parsedBody);
    if (parsedBody['status'] == true) {
      // check if user has completed 2 or 6 referrals

      if (parsedBody['result'].length > 1) {
        String wcBonus = parsedBody['result'][0]['bonus'];
        String bnDate = parsedBody['result'][0]['bonus_date'];
        String ulDate = parsedBody['result'][0]['unlock_date'];
        String secondBonus = parsedBody['result'][1]['bonus'];
        String secondBonusDate = parsedBody['result'][1]['bonus_date'];
        String secondBonusUnlockDate = parsedBody['result'][1]['unlock_date'];
        if (this.mounted) {
          setState(() {
            hasData = true;
            multiJson = true;
            bonus = wcBonus;
            bonusDate = bnDate;
            unlockDate = ulDate;
            sBonus = secondBonus;
            sBonusDate = secondBonusDate;
            sBonusUnlockDate = secondBonusUnlockDate;
          });
        }
      } else {
        String wcBonus = parsedBody['result'][0]['bonus'];
        String bnDate = parsedBody['result'][0]['bonus_date'];
        String ulDate = parsedBody['result'][0]['unlock_date'];
        setState(() {
          hasData = true;
          bonus = wcBonus;
          bonusDate = bnDate;
          unlockDate = ulDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
            ),
          ),
          title: Text('Welcome Bonus'),
          centerTitle: true),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/welcome.png',
                      width: double.infinity,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Welcome Bonus : ${bonus} CNL'),
                                    SizedBox(height: 10),
                                    Text('Bonus Date : ${bonusDate}'),
                                    SizedBox(height: 10),
                                    Text('Bonus Unlock Date : ${unlockDate}'),
                                    SizedBox(height: 10),
                                    Text('* Bonus for completing 2 referrals',
                                        style: TextStyle(color: Colors.red))
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                hasData
                                    ? Image.asset(
                                        'assets/images/right.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      )
                                    : Image.asset(
                                        'assets/images/warning.png',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      )
                              ]),
                        )),
                    if (multiJson)
                      Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Welcome Bonus : ${sBonus} CNL'),
                                      SizedBox(height: 10),
                                      Text('Bonus Date : ${sBonusDate}'),
                                      SizedBox(height: 10),
                                      Text(
                                          'Bonus Unlock Date : ${sBonusUnlockDate}'),
                                      SizedBox(height: 10),
                                      Text('* Bonus for completing 6 referrals',
                                          style: TextStyle(color: Colors.red))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  hasData
                                      ? Image.asset(
                                          'assets/images/right.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        )
                                      : Image.asset(
                                          'assets/images/warning.png',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                        )
                                ]),
                          )),
                    SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: hasData
                          ? multiJson
                              ? Text(
                                  'Congratulations ! you have successfully completed ${usercount} referrals, you have received ${int.parse(bonus) + int.parse(sBonus)} CNL coins. The bonus CNL will be unlocked on above mentioned dates.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  'Congratulations ! you have successfully completed ${usercount} referrals, you have received ${bonus} CNL coins. Your bonus CNL will be unlocked on ${unlockDate}.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )
                          : Text(
                              'Congratulations ! you have received welcome bonus 100 CNL. To unlock the bonus CNL please complete atleast 2 referrals',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ]))),
    );
  }
}
