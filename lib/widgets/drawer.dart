import '../helpers/session.dart';
import '../screens/f_wallet_screen.dart';
import '../screens/robot_trading.dart';
import '../screens/withdrawl.dart';

import '../screens/history_page.dart';
import '../screens/income_history_screen.dart';
import '../screens/kyc_screen.dart';
import '../screens/ledger_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/referearn.dart';
import 'package:flutter/material.dart';
import '../screens/wallet_transfer.dart';

class drawer extends StatefulWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  var firstName = '';
  var lastN = '';

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  Future getUserData() async {
    final fname = await StoreSession.getFirstName();
    final lastname = await StoreSession.getLastname();
    setState(() {
      firstName = fname;
      lastN = lastname;
    });
  }

  Widget _createHeader() {
    return DrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff0D1180),
            Color(0xff0024DB),
            Color(0xff1A22FF),
          ]),
        ),
        child: Stack(children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                  margin: const EdgeInsets.symmetric(vertical: 0),
                  width: 90.0,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/person.png",
                        scale: 2,
                      ),
                      // Expanded(
                      //   child: Text('${firstName} ${lastN}',
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 16.0,
                      //           fontWeight: FontWeight.bold)),
                      // ),
                    ],
                  )),
            ],
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            _createHeader(),
            // const Divider(
            //   height: 30,
            // ),
            InkWell(
              onTap: () {
                Navigator.of(context).popAndPushNamed(ProfileScreen.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.person_add_outlined,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Profile'),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.of(context)
                    .popAndPushNamed(IncomeHistoryScreen.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.history,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Income History'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).popAndPushNamed(History.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.replay_circle_filled,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Staking History'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(walletTransfer.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Send CNL'),
                // trailing: Text(
                //   'Not verified',
                //   style: TextStyle(
                //       color: Colors.red, fontStyle: FontStyle.italic),
                // )
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(withdrawl.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.price_change_rounded,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Withdraw Funds'),
                // trailing: Text(
                //   'Not verified',
                //   style: TextStyle(
                //       color: Colors.red, fontStyle: FontStyle.italic),
                // )
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed(topfive.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.people_alt_outlined,
                  size: 30,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Weekly Top 5 Referral Achievers'),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed(adharVerification.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.people_alt_outlined,
                  size: 30,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Highest Earners of The Month (Top 20)'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ledgerReport.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.account_balance,
                  size: 30,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Ledger Report'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(KycScreen.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.payments_outlined,
                  size: 30,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Utilities'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(robottrading.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.payments_outlined,
                  size: 30,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Trading Bot'),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(FwalletScreen.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.payments_outlined,
                  size: 30,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Franchise wallet'),
              ),
            ),

            Divider(
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(referearn.routename);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.groups_outlined,
                  size: 30,
                  color: Color(0xff1A22FF),
                ),
                title: Text('Refer & Earn'),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            ListTile(
              title: Row(
                children: [
                  Text(
                    'Version - ',
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    '1.2.0',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

Widget _createDrawerItem(
    {required IconData icon,
    required String text,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
