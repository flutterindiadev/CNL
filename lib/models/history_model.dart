class HistoryData {
  String transactionId;
  String stakePlanId;
  String numberofCoins;
  String transactionDate;
  String maturityDate;
  HistoryData({
    required this.transactionId,
    required this.stakePlanId,
    required this.numberofCoins,
    required this.transactionDate,
    required this.maturityDate,
  });
  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      transactionId: json['coinlee_coins_hold_id'].toString(),
      stakePlanId: json['plan_id'].toString(),
      numberofCoins: json['coin_closing'].toString(),
      transactionDate: json['transaction_date'].toString(),
      maturityDate: json['maturity_date'].toString(),
    );
  }
}
