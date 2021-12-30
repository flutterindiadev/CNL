import 'dart:convert';

import '../constants/appurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/session.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key}) : super(key: key);

  static const routename = '/Qr-code';

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String custId = '';
  String imageQr = '';
  bool isLoading = false;
  String mobile = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      getuser().then((value) => getQr());
    });
  }

  Future getuser() async {
    String uMobile = await StoreSession.getUserMobile();
    String fName = await StoreSession.getFirstName();
    String cId = await StoreSession.getCoinleeUserId();
    setState(() {
      mobile = uMobile;
      name = fName;
      custId = cId;
    });
  }

  Future getQr() async {
    setState(() {
      isLoading = true;
    });
    http.post(Uri.parse(Appurl.qrcode), body: {
      'mobile': mobile,
      'name': name,
      'cus_id': custId,
    }).then((response) {
      print(response.body);
      if (response.body != null) {
        if (json.decode(response.body)['status'] = true) {
          String qrImg = json.decode(response.body)['result'];
          setState(() {
            imageQr = qrImg;
            isLoading = false;
          });
        }
      } else {
        print('something went wrong');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments;

    String amount = (int.parse(routeArgs.toString()) * 80).toString();

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1A22FF), Color(0xff0D1180)],
              ),
            ),
          ),
          title: Text('QR code Payment'),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: Image.network(
                            'https://developer.satmatgroup.com/coinlee/$imageQr'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Amount : $amount',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                            '''1. Please scan and Pay on above QR using any UPI App \n2.Coins will be automatically added in your account at Real-time \n3. Pay the same amount as you see Above'''),
                      )
                    ],
                  ),
                ),
              ));
  }
}
