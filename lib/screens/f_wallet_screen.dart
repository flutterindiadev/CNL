import 'dart:convert';

import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../constants/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class FwalletScreen extends StatefulWidget {
  const FwalletScreen({Key? key}) : super(key: key);

  static const routename = '/FwalletScreen';

  @override
  _FwalletScreenState createState() => _FwalletScreenState();
}

class _FwalletScreenState extends State<FwalletScreen> {
  TextEditingController AmountController = TextEditingController();
  TextEditingController MobileNumberController = TextEditingController();

  // String coinleeUserId = '';
  String receiverUserId = '';
  // String token = '';
  // String mobile = '';
  String receiverName = '';
  String FranchiseAvailableCoins = '0';
  bool receiverVerifield = false;
  bool isLoading = true;
  bool isFranchise = false;

  @override
  void dispose() {
    AmountController.dispose();
    MobileNumberController.dispose();
    super.dispose();
  }

  Future verifyReceiver() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    final response = await http.post(Uri.parse(Appurl.verifyUser), body: {
      'coinlee_user_mobile': MobileNumberController.text,
      'token': userData.user.token
    });
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
        content: Text('User Not Found!!!'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future sendCNL() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
    if (AmountController.text.isNotEmpty &&
        MobileNumberController.text.isNotEmpty) {
      final response =
          await http.post(Uri.parse(Appurl.transferFromFranchise), body: {
        'no_of_coins': AmountController.text,
        'coinlee_user_id_to': receiverUserId,
        'coinlee_user_id_from': userData.user.userId,
        'coinlee_user_mobile_to': MobileNumberController.text,
        'coinlee_user_mobile_from': userData.user.userMobile,
        'token': userData.user.token
      });
      if (json.decode(response.body)['status'] == true) {
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
                            MobileNumberController.text = '';
                          },
                          child: Text('Okay')),
                    )
                  ],
                ),
              );
            });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Insufficient funds'),
          backgroundColor: Colors.red,
        ));
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

  Future getAvailableCoins() async {
    final userData = Provider.of<AuthProvider>(context);
    final response =
        await http.post(Uri.parse(Appurl.franchisewalletbalance), body: {
      'coinlee_user_id': userData.user.userId,
      'coinlee_user_mobile': userData.user.userMobile,
      'token': userData.user.token,
    });
    if (response.statusCode == 200) {
      if (json.decode(response.body)['status'] == true) {
        print(response.body);
        FranchiseAvailableCoins =
            num.parse(json.decode(response.body)['wallet_balance'])
                .toStringAsFixed(0);

        // check franchisee balance
        if (num.parse(FranchiseAvailableCoins) > 0) {
          setState(() {
            isFranchise = true;
            isLoading = false;
          });
        }
      }
      setState(() {
        FranchiseAvailableCoins;
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getAvailableCoins();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : isFranchise
                ? WillPopScope(
                    onWillPop: () async => false,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomPaint(
                            child: Container(),
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
                                    'Franchisee Wallet Transfer',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 15),
                            child: isFranchise
                                ? Text(
                                    "Franchise Status : Active",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )
                                : Text(
                                    "Franchise Status : Not Active",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              FranchiseAvailableCoins,
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              "Available Franchisee CNL",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                  child: Column(
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
                                        onEditingComplete: verifyReceiver,
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
                                                  FranchiseAvailableCoins)) {
                                            AmountController.text =
                                                FranchiseAvailableCoins;
                                          }
                                        },
                                        style: const TextStyle(fontSize: 15),
                                        controller: AmountController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            suffix: Text('CNL'),
                                            label: const Text(
                                              'No of CNL',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            hintText: 'Enter No of CNL',
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                      SizedBox(height: 15),
                                      SizedBox(height: 15),
                                      receiverVerifield
                                          ? InkWell(
                                              child: MyButton(text: 'Send'),
                                              onTap: sendCNL)
                                          : InkWell(
                                              child: isLoading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : MyButton(
                                                      text: 'Verify User'),
                                              onTap: verifyReceiver)
                                    ],
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                    'Franchisee Status : Inactive',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  )),
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
