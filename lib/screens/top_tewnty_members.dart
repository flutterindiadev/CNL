import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class toptwenty extends StatefulWidget {
  const toptwenty({Key? key}) : super(key: key);

  static const routename = '/toptwenty';

  @override
  _toptwentyState createState() => _toptwentyState();
}

class _toptwentyState extends State<toptwenty> {
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
        body: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Column(
                                  children: [
                                    Text(
                                      "RANK",
                                      style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${index + 1}".toString(),
                                      style: GoogleFonts.lobster(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Name : Rituja",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Coins Buy by Referal: 100",
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Referal Coins : 12",
                                              style: TextStyle(fontSize: 12)),
                                          Text("Interset % : 12",
                                              style: TextStyle(fontSize: 12)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
