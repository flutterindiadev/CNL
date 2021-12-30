import 'package:flutter/material.dart';

class coinCard extends StatelessWidget {
  coinCard({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
  });

  double change;
  double changePercentage;
  String imageUrl;
  String name;
  double price;
  String symbol;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     offset: Offset(4, 4),
          //     blurRadius: 10,
          //     spreadRadius: 1,
          //   ),
          //   BoxShadow(
          //     color: Colors.white,
          //     offset: Offset(-4, -4),
          //     blurRadius: 10,
          //     spreadRadius: 1,
          //   ),
          // ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey,
                  //     offset: Offset(4, 4),
                  //     blurRadius: 10,
                  //     spreadRadius: 1,
                  //   ),
                  // BoxShadow(
                  //   color: Colors.white,
                  //   offset: Offset(-4, -4),
                  //   blurRadius: 10,
                  //   spreadRadius: 1,
                  // ),
                  // ],
                ),
                height: 60,
                width: 60,
                child:
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child:
                    Image.network(imageUrl),
              ),
            ),
            // ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      symbol,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price.toDouble().toString(),
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    change.toDouble() < 0
                        ? change.toDouble().toStringAsFixed(4)
                        : '+' + change.toDouble().toStringAsFixed(4),
                    style: TextStyle(
                      color: change.toDouble() < 0 ? Colors.red : Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                      changePercentage.toDouble() < 0
                          ? changePercentage.toDouble().toStringAsFixed(4) + '%'
                          : '+' +
                              changePercentage.toDouble().toStringAsFixed(4) +
                              '%',
                      style: TextStyle(
                        color: changePercentage.toDouble() < 0
                            ? Colors.red
                            : Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
