import 'package:coinlee/screens/income_screen.dart';
import 'package:coinlee/screens/staking_details_screen.dart';

import 'screens/animation.dart';
import 'screens/f_wallet_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/usdt_payment_screen.dart';
import 'package:flutter/material.dart';

import 'helpers/auth_provider.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'screens/wallet_transfer.dart';
import 'screens/welcomeBonusScreen.dart';
import 'screens/withdrawl.dart';
import 'screens/qr_code.dart';
import 'screens/route_payment_screen.dart';
import 'screens/ledger_screen.dart';
import 'screens/buy_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/history_page.dart';
import 'screens/income_history_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/person_history.dart';
import 'screens/plan_details.dart';
import 'screens/profile_screen.dart';
import 'screens/referearn.dart';
import 'screens/robot_trading.dart';
import 'screens/signup_screen.dart';
import 'screens/stake_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Push notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // persistance storage
  const _storage = FlutterSecureStorage();
  var jwt = (await _storage.read(key: 'token'));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => AuthProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coinlee',
      theme: ThemeData(
        primarySwatch: const MaterialColor(4280364698, {
          50: Color(0xffeaecfb),
          100: Color(0xffd5d9f6),
          200: Color(0xffabb2ed),
          300: Color(0xff818ce4),
          400: Color(0xff5765db),
          500: Color(0xff2d3fd2),
          600: Color(0xff2432a8),
          700: Color(0xff1b267e),
          800: Color(0xff121954),
          900: Color(0xff090d2a)
        }),
        brightness: Brightness.light,
        primaryColor: Color(0xff212e9a),
        primaryColorBrightness: Brightness.dark,
        primaryColorLight: Color(0xffd5d9f6),
        primaryColorDark: Color(0xff1b267e),
        accentColor: Color(0xff2d3fd2),
        accentColorBrightness: Brightness.dark,
        canvasColor: Color(0xfffafafa),
        scaffoldBackgroundColor: Color(0xfffafafa),
        bottomAppBarColor: Color(0xffffffff),
        cardColor: Color(0xffffffff),
        dividerColor: Color(0x1f000000),
        highlightColor: Color(0x66bcbcbc),
        splashColor: Color(0x66c8c8c8),
        selectedRowColor: Color(0xfff5f5f5),
        unselectedWidgetColor: Color(0x8a000000),
        disabledColor: Color(0x61000000),
        buttonColor: Color(0xffe0e0e0),
        toggleableActiveColor: Color(0xff2432a8),
        secondaryHeaderColor: Color(0xffeaecfb),
        textSelectionColor: Color(0xffabb2ed),
        cursorColor: Color(0xff4285f4),
        textSelectionHandleColor: Color(0xff818ce4),
        backgroundColor: Color(0xffabb2ed),
        dialogBackgroundColor: Color(0xffffffff),
        indicatorColor: Color(0xff2d3fd2),
        hintColor: Color(0x8a000000),
        errorColor: Color(0xffd32f2f),
        buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.normal,
            minWidth: 88,
            height: 36,
            padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Color(0xff000000),
                width: 0,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            )),
      ),
      initialRoute: jwt == null ? "/" : "dashboard",
      routes: {
        "/": (ctx) => SplashScreen(),
        "dashboard": (ctx) => const DashboardScreen(),
        OtpScreen.routename: (ctx) => OtpScreen(),
        DashboardScreen.routename: (ctx) => const DashboardScreen(),
        BuyScreen.routename: (ctx) => const BuyScreen(),
        // KycScreen.routename: (ctx) => const KycScreen(),
        ProfileScreen.routename: (ctx) => ProfileScreen(),
        SignUpScreen.routename: (ctx) => const SignUpScreen(),
        History.routename: (ctx) => const History(),
        StakeScreen.routename: (ctx) => StakeScreen(),
        plandetails.routename: (ctx) => const plandetails(),
        IncomeHistoryScreen.routename: (ctx) => const IncomeHistoryScreen(),
        // PaymentScreen.routename: (ctx) => const PaymentScreen(),
        // MakePaymentScreen.routename: (ctx) => const MakePaymentScreen(),
        robottrading.routename: (ctx) => robottrading(),
        // toptwenty.routename: (ctx) => const toptwenty(),
        personhistory.routename: (ctx) => const personhistory(),
        referearn.routename: (ctx) => const referearn(),
        ledgerReport.routename: (ctx) => const ledgerReport(),
        RoutePaymentScreen.routename: (ctx) => const RoutePaymentScreen(),
        UsdtPaymentScreen.routename: (ctx) => const UsdtPaymentScreen(),
        QrCodeScreen.routename: (ctx) => const QrCodeScreen(),
        withdrawl.routename: (ctx) => const withdrawl(),
        WelcomeBonusScreen.routename: (ctx) => WelcomeBonusScreen(),
        walletTransfer.routename: (ctx) => walletTransfer(),
        StakeSuccess.routename: (ctx) => StakeSuccess(),
        FwalletScreen.routename: (ctx) => FwalletScreen(),
        StakeDetailsScreen.routename: (ctx) => StakeDetailsScreen(),
        IncomeScreen.routename: (ctx) => IncomeScreen()
      },
    ),
  ));
}
