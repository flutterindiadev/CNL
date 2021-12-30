import 'package:flutter/material.dart';

class Singleton {
  static void showSuccess(BuildContext context, title, image, noOfcoins,
      OrderId, Intersetrate, maturitydate) {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Container(
              // height: MediaQuery.of(context).size.height/2,
              child: AlertDialog(
                backgroundColor: Colors.white,
                title: Text(title),
                // content: Image.network(image,scale: 3,),
                content: Column(
                  children: [
                    Image.network(image),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "No of Coins: $noOfcoins",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Order Id: $OrderId",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Staking Bonus : $Intersetrate",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Maturity Date: $maturitydate",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
// static void checkInternetConnectivity(context) async {
// var result = await Connectivity().checkConnectivity();
// if (result == ConnectivityResult.none) {
//   Singleton.showmsg(
//       context, 'No Internet', "You have not connected to any network");
// }
}

// static void toastMessage(String message) {
//   Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.TOP,
//       timeInSecForIos: 1,
//       fontSize: 16.0);
// }

//---------------------------checking the InternetConnectivity----------------------------------------------

