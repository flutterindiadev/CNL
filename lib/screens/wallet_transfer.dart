import 'dart:convert';
import 'dart:io';

import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../constants/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';

class walletTransfer extends StatefulWidget {
  const walletTransfer({Key? key}) : super(key: key);

  static const routename = '/walletTransfer';

  @override
  _walletTransferState createState() => _walletTransferState();
}

class _walletTransferState extends State<walletTransfer> {
  TextEditingController AmountController = TextEditingController();
  TextEditingController MobileNumberController = TextEditingController();
  TextEditingController UserIdController = TextEditingController();
  bool isLoading = false;
  bool isSending = true;
  String receiverName = '';
  String receiverUserId = '';
  bool receiverVerifield = false;

  final _screenshotController = ScreenshotController();

  @override
  void dispose() {
    AmountController.dispose();
    UserIdController.dispose();
    MobileNumberController.dispose();
    super.dispose();
  }

  void _capturebarcode() async {
    await _screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }
    });
  }

  Future verifyReceiver(token) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(Appurl.verifyUser), body: {
      'coinlee_user_mobile': MobileNumberController.text,
      'token': token
    });
    print(response.body);
    if (json.decode(response.body)['status'] == true) {
      String firstName =
          json.decode(response.body)['result'][0]['user_first_name'];
      String lastName =
          json.decode(response.body)['result'][0]['user_last_name'];
      String recUserId =
          json.decode(response.body)['result'][0]['coinlee_user_id'];
      setState(() {
        receiverName = firstName + ' ' + lastName;
        receiverVerifield = true;
        receiverUserId = recUserId;
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User not found'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future sendCNL(coinleeUserId, mobile, token) async {
    setState(() {
      isLoading = true;
    });
    if (AmountController.text.isNotEmpty &&
        MobileNumberController.text.isNotEmpty) {
      final response = await http.post(Uri.parse(Appurl.transferCoins), body: {
        'no_of_coins': AmountController.text,
        'coinlee_user_id_to': receiverUserId,
        'coinlee_user_id_from': coinleeUserId,
        'coinlee_user_mobile_to': MobileNumberController.text,
        'coinlee_user_mobile_from': mobile,
        'token': token
      });
      print(response.body);
      if (json.decode(response.body)['status'] == true) {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: AlertDialog(
                  title: Text('Sent Successfully'),
                  content: Text(
                      'You have successfully sent ${AmountController.text} CNL to ${receiverName}'),
                  actions: [
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            AmountController.text = '';
                            UserIdController.text = '';
                            MobileNumberController.text = '';
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('Okay')),
                    )
                  ],
                ),
              );
            });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter Amount & Receiver Mobile Number'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> readBarcode() async {
    try {
      String scannedMobile = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (this.mounted) {
        setState(() {
          MobileNumberController.text = scannedMobile;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
        //     ),
        //   ),
        //   title: const Text('Wallet Transfer'),
        //   centerTitle: true,
        // ),
        body: WillPopScope(
          onWillPop: () async => false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomPaint(
                  child: Container(
                      // width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      ),
                  painter: HeaderCurvedContainer(),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 40,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Wallet Transfer',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                //   child: Text(
                //     "Send CNL using Mobile Number",
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    userData.user.availableCoins,
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Available CNL",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isSending = true;
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.send_to_mobile,
                                      size: 30,
                                      color: Color(0xff1A22FF),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Send CNL",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isSending = false;
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.get_app,
                                      size: 30,
                                      color: Color(0xff1A22FF),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Receive CNL",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 347,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: isSending
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text('Enter Receiver details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(height: 15),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  style: const TextStyle(fontSize: 15),
                                  controller: MobileNumberController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          child: Icon(Icons.qr_code),
                                          onTap: readBarcode),
                                      label: const Text(
                                        'Mobile Number',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      hintText: 'Enter Mobile Number',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onEditingComplete: () {
                                    verifyReceiver(userData.user.token);
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('Receiver Name : ${receiverName}'),
                                SizedBox(height: 5),
                                TextFormField(
                                  onChanged: (val) {
                                    if (num.parse(val) >
                                        num.parse(
                                            userData.user.availableCoins)) {
                                      AmountController.text =
                                          userData.user.availableCoins;
                                    }
                                  },
                                  style: const TextStyle(fontSize: 15),
                                  controller: AmountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      suffix: Text('CNL'),
                                      label: const Text(
                                        'No. of CNL',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      hintText: 'Enter No. of CNL',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                SizedBox(height: 15),
                                SizedBox(height: 15),
                                receiverVerifield
                                    ? InkWell(
                                        child: MyButton(text: 'Send'),
                                        onTap: () {
                                          sendCNL(
                                              userData.user.userId,
                                              userData.user.userMobile,
                                              userData.user.token);
                                        })
                                    : InkWell(
                                        child: isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : MyButton(text: 'Verify User'),
                                        onTap: () {
                                          verifyReceiver(userData.user.token);
                                        })
                              ],
                            )
                          : Column(
                              children: [
                                Center(
                                  child: Screenshot(
                                    controller: _screenshotController,
                                    child: QrImage(
                                      backgroundColor: Colors.white,
                                      data: userData.user.userMobile,
                                      size: 200.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                IconButton(
                                    onPressed: _capturebarcode,
                                    icon: Icon(Icons.share)),
                                Text('Share QR code')
                              ],
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff1A22FF);
    Path path = Path()
      ..relativeLineTo(0, 180)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 180)
      ..relativeLineTo(0, -180)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
