class Referal {
  String userId;
  String firstName;
  String lastName;
  String totalCoinPurchase;
  String totalCoinsReceivedbyReferer;
  String intrestCoinsAgainstHolding;
  String referMobile;
  String referEmail;
  Referal(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.totalCoinPurchase,
      required this.totalCoinsReceivedbyReferer,
      required this.intrestCoinsAgainstHolding,
      required this.referMobile,
      required this.referEmail});
  factory Referal.fromJson(Map<String, dynamic> json) {
    return Referal(
        userId: json['coinlee_user_id'].toString(),
        firstName: json['user_first_name'].toString(),
        lastName: json['user_last_name'].toString(),
        totalCoinPurchase: json['total_coins_purchase'].toString(),
        totalCoinsReceivedbyReferer:
            json['total_coins_received_by_referer'].toString(),
        intrestCoinsAgainstHolding:
            json['intrest_coins_against_holding'].toString(),
        referMobile: json['user_mobile'].toString(),
        referEmail: json['user_email'].toString());
  }
}
