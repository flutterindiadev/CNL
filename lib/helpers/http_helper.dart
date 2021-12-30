import 'package:http/http.dart' as http;

const signinUrl =
    'https://developer.satmatgroup.com/coinlee/Applogin/verifyUserMobile';

Future verifyMobile(mobile, otp) async {
  http.post(Uri.parse(signinUrl), body: {
    'userMobile': mobile,
    'otp': otp,
  });
}

const loginUrl = 'https://developer.satmatgroup.com/coinlee/Applogin/userLogin';

Future login(usermobile, deviceId) async {
  http.post(Uri.parse(loginUrl), body: {
    'userMobile': usermobile,
    'deviceId': deviceId,
    'devicename': 'demo'
  });
}

const historyUrl =
    'https://developer.satmatgroup.com/coinlee/appapi/getUserHoldingHistory';

Future getHistory(userId, userMobile) async {
  http.post(Uri.parse(historyUrl),
      body: {'coinlee_user_id': userId, 'userMobile': userMobile});
}

const getHistoryDetails =
    'https://developer.satmatgroup.com/coinlee/appapi/getUserHoldingHistory';

Future getHistoryDetail(userId, userMobile, coinHoldId) async {
  http.post(Uri.parse(getHistoryDetails), body: {
    'coinlee_user_id': userId,
    'userMobile': userMobile,
    'coinlee_coins_hold_id': coinHoldId
  });
}

// Future<void> getReferral(userId) async {
//   const referralUrl =
//       'https://developer.satmatgroup.com/coinlee/appapi/getUserReferalDetails';

//   http.post(Uri.parse(referralUrl), body: {'coinlee_user_id': userId});
// }

