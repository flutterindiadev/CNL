import 'dart:convert';

import '../constants/appurl.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'session.dart';

class User {
  String firstName;
  String lastName;
  String token;
  String userEmail;
  String userId;
  String userMobile;
  String userReferalCode;
  String availableCoins;
  String holdingCoins;
  String totalEarnings;
  String totalWithdrawl;
  String welcomeBonus;
  String cnlRate;
  String usdRate;
  User(
      {required this.firstName,
      required this.lastName,
      required this.token,
      required this.userEmail,
      required this.userId,
      required this.userMobile,
      required this.userReferalCode,
      required this.availableCoins,
      required this.holdingCoins,
      required this.totalEarnings,
      required this.totalWithdrawl,
      required this.welcomeBonus,
      required this.cnlRate,
      required this.usdRate});
}

class AuthProvider extends ChangeNotifier {
  User _user = (User(
      firstName: '',
      lastName: '',
      token: '',
      userEmail: '',
      userId: '',
      userMobile: '',
      userReferalCode: '',
      availableCoins: '0',
      holdingCoins: '0',
      totalEarnings: '0',
      totalWithdrawl: '0',
      welcomeBonus: '0',
      cnlRate: '0',
      usdRate: '0'));

  User get user => _user;

  Future loginWithOTP(String mobile, String deviceId) async {
    final response = await http.post(Uri.parse(Appurl.loginUrl), body: {
      'userMobile': mobile,
      'deviceId': deviceId,
      'deviceName': 'demo',
    });
    if (json.decode(response.body)['status'] == true) {
      _user = User(
        userId: json.decode(response.body)['result'][0]['coinlee_user_id'],
        firstName: json.decode(response.body)['result'][0]['first_name'],
        lastName: json.decode(response.body)['result'][0]['last_name'],
        userMobile: json.decode(response.body)['result'][0]['user_mobile'],
        userEmail: json.decode(response.body)['result'][0]['user_email'],
        userReferalCode: json.decode(response.body)['result'][0]
            ['user_referal_code'],
        token: json.decode(response.body)['token'],
        cnlRate: '0',
        usdRate: '0',
        availableCoins: '0',
        holdingCoins: '0',
        totalEarnings: '0',
        totalWithdrawl: '0',
        welcomeBonus: '0',
      );
      StoreSession.setcoinleeUserId(_user.userId);
      StoreSession.setFirstName(_user.firstName);
      StoreSession.setlastName(_user.lastName);
      StoreSession.setuserMobile(_user.userMobile);
      StoreSession.setuserEmail(_user.userEmail);
      StoreSession.setToken(_user.token);
      StoreSession.setReferralCode(_user.userReferalCode);
    }
    notifyListeners();
  }

  Future getAvailableCoins(BuildContext context) async {
    final response = await http.post(Uri.parse(Appurl.getusercoins), body: {
      'coinlee_user_id': _user.userId,
      'userMobile': _user.userMobile,
      'token': _user.token,
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == true) {
        _user.availableCoins =
            num.parse(json.decode(response.body)['available_coins'])
                .toStringAsFixed(2);
        _user.holdingCoins =
            num.parse(json.decode(response.body)['holding_coins'])
                .toStringAsFixed(2);
        _user.totalEarnings =
            num.parse(json.decode(response.body)['total_earning'])
                .toStringAsFixed(2);
        _user.totalWithdrawl = json.decode(response.body)['total_withdrwal'];
        _user.cnlRate = json.decode(response.body)['coin_inr_rate'];
        _user.usdRate = json.decode(response.body)['usd_rate'];
      }
      if (json.decode(response.body)['status'] == false &&
          json.decode(response.body)['message'] == 'Expired token') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Security Token Expired, Please login again'),
          backgroundColor: Colors.red,
        ));
        // _user.firstName = '';
        // _user.lastName = '';
        // _user.token = '';
        // _user.userEmail = '';
        // _user.userId = '';
        // _user.userMobile = '';
        // _user.userReferalCode = '';
        // _user.availableCoins = '0';
        // _user.holdingCoins = '0';
        // _user.totalEarnings = '0';
        // _user.totalWithdrawl = '0';
        // _user.welcomeBonus = '0';
        // _user.cnlRate = '0';
        // _user.usdRate = '0';
        StoreSession.clearSession();
      }
    }
  }

  Future getBonus() async {
    final response = await http.post(Uri.parse(Appurl.welcomeBonus), body: {
      'coinlee_user_id': _user.userId,
      'token': _user.token,
    });
    final parsedBody = json.decode(response.body);
    if (parsedBody['status'] == true) {
      if (parsedBody['result'].length > 1) {
        _user.welcomeBonus = (int.parse(parsedBody['result'][0]['bonus']) +
                int.parse(parsedBody['result'][1]['bonus']))
            .toString();
      } else {
        _user.welcomeBonus = parsedBody['result'][0]['bonus'];
      }
    }
  }
}
