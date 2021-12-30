import 'dart:convert';

import '../helpers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../helpers/usdt_gateway.dart';

class UsdtPaymentScreen extends StatefulWidget {
  const UsdtPaymentScreen({Key? key}) : super(key: key);

  static const routename = '/usdt-payment';

  @override
  State<UsdtPaymentScreen> createState() => _UsdtPaymentScreenState();
}

class _UsdtPaymentScreenState extends State<UsdtPaymentScreen> {
  String storedAddress = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createUsdtAddress();
  }

  Future getQrwithAddress() async {
    final addressIn = storedAddress;
    generateQr(addressIn).then((response) {
      String QrString = json.decode(response)['qr_code'];
    });
  }

  Future createUsdtAddress() async {
    final usermobile = Provider.of<AuthProvider>(context).user.userMobile;
    const address = 'TGT1AMovuNjaQMnxTNRfUxLQnG7J9W4QJL';
    const email = 'coinleeinfo@gmail.com';
    final callback =
        'https://developer.satmatgroup.com/coinlee/api_callback/usdtcalback/$usermobile';
    final addUrl =
        'https://api.cryptapi.io/trc20/usdt/create/?callback=$callback&address=$address&pending=1&confirmations=1&email=$email&post=1';

    http.get(Uri.parse(addUrl)).then((response) {
      print(response.body);
      if (response != null) {
        final addIn = json.decode(response.body)['address_in'];
        setState(() {
          storedAddress = addIn;
        });
      } else {
        print('something went wrong');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments;
    String usdtAmount = routeArgs.toString();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1A22FF), Color(0xff0D1180)],
            ),
          ),
        ),
        title: Text('USDT Payment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Column(children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(border: Border.all()),
              child: Center(
                child: QrImage(
                  data: storedAddress,
                  size: 200.0,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Deposit Address : ',
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  storedAddress,
                  textAlign: TextAlign.center,
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: storedAddress))
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                  SnackBar(content: Text('Copied!'))));
                    },
                    icon: Icon(
                      Icons.copy,
                    ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text('Amount : $usdtAmount USDT'),
            SizedBox(
              height: 10,
            ),
            Text('Network : Tron(TRC20)'),
          ]),
        ),
      ),
    );
  }
}
