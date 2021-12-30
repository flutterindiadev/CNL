import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile(
      {Key? key,
      required this.transactionId,
      required this.transactionDate,
      required this.maturityDate,
      required this.numberofCoins,
      required this.stakePlanId})
      : super(key: key);

  final String maturityDate;
  final String numberofCoins;
  final String stakePlanId;
  final String transactionDate;
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black45),
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Transaction Date: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(transactionDate)
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Maturity Date: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(maturityDate),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Number of Coinlee : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(numberofCoins),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Plan Id : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(stakePlanId),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Bonus : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    stakePlanId == '1'
                        ? Text('3%')
                        : stakePlanId == '2'
                            ? Text('4 %')
                            : stakePlanId == '3'
                                ? Text('5 %')
                                : Text('Something went wrong')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
