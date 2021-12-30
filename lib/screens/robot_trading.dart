import 'package:flutter/material.dart';

class robottrading extends StatelessWidget {
  static const routename = '/robottrading';

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset("assets/images/robotbanner.jpeg")),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What is Robot Trading ?",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "OverView -",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "1. Robot trading with 100% accuracy",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "2. Robot trading is Powered by Artificial Intellegence and Machine Learning",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "3. It is supported by WazirX, Binance",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "4. Cryptocurrency robots exploiting the difference in prices between the numerous cryptocurrency exchanges",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            ),
            Text(
              "Coming soon...",
              style: TextStyle(color: Colors.red, fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
