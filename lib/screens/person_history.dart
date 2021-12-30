import '../constants/appurl.dart';

import '../helpers/session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class personhistory extends StatefulWidget {
  const personhistory({Key? key}) : super(key: key);

  static const routename = '/personhistory';

  @override
  _personhistoryState createState() => _personhistoryState();
}

class _personhistoryState extends State<personhistory> {
  String Id = '';
  String coinleeId = '';
  String token = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 2), () async {
      final userId = ModalRoute.of(context)!.settings.arguments;
      print(userId.toString());
      setState(() {
        Id = userId.toString();
      });
    }).then((value) => getToken().then((value) => loadRefTransactions()));
  }

  Future loadRefTransactions() async {
    print(coinleeId);
    print(Id);
    print(token);
    http.post(Uri.parse(Appurl.referalTransaction), body: {
      'coinlee_user_id': coinleeId,
      'refered_coinlee_user_id': Id,
      'token': token
    }).then((response) => print(response.body));
  }

  Future getToken() async {
    final userid = await StoreSession.getCoinleeUserId();
    final ctoken = await StoreSession.getToken();
    setState(() {
      coinleeId = userid;
      token = ctoken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff1A22FF), Color(0xff0D1180)],
                ),
              ),
            ),
            title: const Text('Coinlee'),
            centerTitle: true,
          ),
          body: Center(
            child: Text('No transactions found'),
          )
          // SingleChildScrollView(
          //   physics: ScrollPhysics(),
          //   child: ListView.builder(
          //       itemCount: 2,
          //       shrinkWrap: true,
          //       itemBuilder: (context, index) {
          //         return Column(
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(8.0),
          //               child: Card(
          //                 elevation: 5,
          //                 shape: const RoundedRectangleBorder(
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(10))),
          //                 child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Padding(
          //                           padding: const EdgeInsets.all(5),
          //                           child: Text("Name : Dummy name",
          //                               style: TextStyle(
          //                                   fontSize: 14,
          //                                   fontWeight: FontWeight.w600)),
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.all(5.0),
          //                           child: Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceBetween,
          //                             children: [
          //                               Text("Referal Coins : 12",
          //                                   style: TextStyle(fontSize: 12)),
          //                               Text("Deposited Coins : 12",
          //                                   style: TextStyle(fontSize: 11)),
          //                             ],
          //                           ),
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.all(5.0),
          //                           child: Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceBetween,
          //                             children: [
          //                               Text("Recurring Income : 19 ",
          //                                   style: TextStyle(fontSize: 12)),
          //                               Text("Last Update: 30-05-2020 ",
          //                                   style: TextStyle(fontSize: 12)),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     )),
          //               ),
          //             ),
          //           ],
          //         );
          //       }),
          // ),
          ),
    );
  }
}
