import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:coinlee/screens/history_page.dart';
import 'package:coinlee/screens/income_screen.dart';
import '../constants/appurl.dart';
import '../helpers/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'package:provider/provider.dart';

import '../constants/mybutton.dart';
import '../helpers/session.dart';
import '../models/coin_model.dart';
import '../widgets/coinCard.dart';
import '../widgets/drawer.dart';
import 'buy_screen.dart';
import 'robot_trading.dart';
import 'stake_screen.dart';
import 'welcomeBonusScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const routename = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isActive = true;
  bool isLoading = false;
  List newBanner = [];

  int _counter = 0;

  @override
  void didChangeDependencies() {
    Provider.of<AuthProvider>(context).getAvailableCoins(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () async {
      getUser().then((_) {
        fetchCoin();
        getBanner();
      });
    });
    super.initState();

    // push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
    });
    final loggedInUser = Provider.of<AuthProvider>(context, listen: false);
    try {
      loggedInUser.user.firstName = await StoreSession.getFirstName();
      loggedInUser.user.lastName = await StoreSession.getLastname();
      loggedInUser.user.token = await StoreSession.getToken();
      loggedInUser.user.userEmail = await StoreSession.getEmail();
      loggedInUser.user.userId = await StoreSession.getCoinleeUserId();
      loggedInUser.user.userMobile = await StoreSession.getUserMobile();
      loggedInUser.user.userReferalCode = await StoreSession.getReferralCode();
      await loggedInUser.getAvailableCoins(context);
      await loggedInUser.getBonus();
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
  }

  Future logout() async {
    StoreSession.clearSession();
  }

  Future<List<Coin>> fetchCoin() async {
    final user = Provider.of<AuthProvider>(context, listen: false);
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        coinList.insert(
            0,
            Coin(
                name: 'Coinlee',
                symbol: 'CNL',
                imageUrl: 'http://coinlee.live/images/logohed.png',
                price: num.parse(
                    (1 / (num.parse(user.user.usdRate) / num.parse(user.user.cnlRate)))
                        .toStringAsFixed(4)),
                change: num.parse(
                    ((1 / (num.parse(user.user.usdRate) / num.parse(user.user.cnlRate))) - 0.16)
                        .toStringAsFixed(4)),
                changePercentage: num.parse(((((1 /
                                    (num.parse(user.user.usdRate) /
                                        num.parse(user.user.cnlRate))) -
                                0.16) /
                            0.16) *
                        100)
                    .toStringAsFixed(4))));
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  Future getBanner() async {
    final userData = Provider.of<AuthProvider>(context, listen: false);
    final body = {'token': userData.user.token};
    final response = await http.post(Uri.parse(Appurl.getBanner), body: body);
    final parsedJson = json.decode(response.body);

    if (parsedJson['status'] == true) {
      for (int i = 0; i < parsedJson['result'].length; i++) {
        newBanner.add(parsedJson['result'][i]['banner_image']);
      }
      setState(() {
        newBanner;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print(userData.user.token);
    return isActive
        ? Scaffold(
            bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BuyScreen()));
                      },
                      child: MyButton(
                        text: "Buy",
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StakeScreen()));
                      },
                      child: MyButton(
                        text: "Stake",
                      )),
                ),
              ],
            ),
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff1A22FF), Color(0xff0D1180)]),
                ),
              ),
              title: const Text('Coinlee'),
              centerTitle: true,
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.person),
                  color: Colors.white,
                  itemBuilder: (context) => [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                  onSelected: (item) => {
                    logout().then(
                        (value) => Navigator.of(context).popAndPushNamed('/'))
                  },
                ),
              ],
            ),
            drawer: const drawer(),
            body: WillPopScope(
              onWillPop: () async {
                return (await showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        title: new Text('Are you sure?'),
                        content: new Text('Do you want to exit the App'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text('No'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: new Text('Yes'),
                          ),
                        ],
                      ),
                    )) ??
                    false;
              },
              child: isLoading
                  ? Center(
                      child: Text('Fetching User Details...'),
                    )
                  : RefreshIndicator(
                      onRefresh: () => userData.getAvailableCoins(context),
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: [
                          CustomPaint(
                            child: Container(),
                            painter: HeaderCurvedContainer(),
                          ),
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text(
                                'Pull to Refresh',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          )),
                          Column(children: [
                            Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                child: CarouselSlider(
                                    items: newBanner.map((i) {
                                      return Builder(
                                          builder: (BuildContext context) {
                                        return Container(
                                          margin: EdgeInsets.all(6.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: NetworkImage(i),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      });
                                    }).toList(),
                                    options: CarouselOptions(
                                      height: 120.0,
                                      enlargeCenterPage: true,
                                      autoPlay: true,
                                      aspectRatio: 16 / 9,
                                      autoPlayCurve: Curves.decelerate,
                                      enableInfiniteScroll: true,
                                      autoPlayAnimationDuration:
                                          Duration(seconds: 1),
                                      viewportFraction: 1,
                                    ))
                                // }),
                                ),
                          ]),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Card(
                                      color: Color(0xFFFDDED5),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Available Coins",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Image.asset(
                                                      "assets/images/available.png",
                                                      scale: 5,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 6.0),
                                                      child: Text(
                                                        "${userData.user.availableCoins}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(History.routename);
                                      },
                                      child: Card(
                                        color: Color(0xFFD5D0FD),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Stake Coins",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Image.asset(
                                                        "assets/images/total.png",
                                                        scale: 5,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${userData.user.holdingCoins}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(IncomeScreen.routename);
                                        //change this navigation
                                      },
                                      child: Card(
                                        color: Color(0xFFD0FDD9),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Total Earnings",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Image.asset(
                                                        "assets/images/earning.png",
                                                        scale: 5,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "  ${userData.user.totalEarnings}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          WelcomeBonusScreen.routename);
                                    },
                                    child: Card(
                                      color: Color(0xFFD0E7FD),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Welcome Bonus",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Image.asset(
                                                      "assets/images/bonus.png",
                                                      scale: 5,
                                                    ),
                                                  ),
                                                  Text(
                                                    "  ${userData.user.welcomeBonus}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(robottrading.routename);
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                        "assets/images/robotbanner.jpeg"))),
                          ),
                          // const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Container(
                                height: height / 2,
                                width: width,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: coinList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return coinCard(
                                              name: coinList[index].name,
                                              symbol: coinList[index].symbol,
                                              imageUrl:
                                                  coinList[index].imageUrl,
                                              price: coinList[index]
                                                  .price
                                                  .toDouble(),
                                              change: coinList[index]
                                                  .change
                                                  .toDouble(),
                                              changePercentage: coinList[index]
                                                  .changePercentage
                                                  .toDouble());
                                        },
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              "Recharge And Bills",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>seemore()));
                                            },
                                            child: Text(
                                              "See More",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/mobile.png',
                                                    scale: 3,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Mobile",
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/dth.png',
                                                    scale: 3,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("DTH",
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/electricity.png',
                                                    scale: 3.5,
                                                  ),
                                                  Text("electricity",
                                                      style: TextStyle(
                                                          fontSize: 11)),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/loanrepayment.png',
                                                    scale: 3.5,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Broadband",
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/cylinder.png',
                                                    scale: 4,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Cylinder",
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/gasconnection.png',
                                                    scale: 4,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Connection",
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // SizedBox(height: 10,),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/water.png',
                                                    scale: 4,
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Water Bill",
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/images/fasttag.png',
                                                    scale: 4,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text("Fastag",
                                                        style: TextStyle(
                                                            fontSize: 11)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
            ),
          )
        : Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    'User has been blocked by admin. Please contact Administrator.',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
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
      ..relativeLineTo(0, 120)
      ..quadraticBezierTo(size.width / 2, 180.0, size.width, 120)
      ..relativeLineTo(0, -120)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
