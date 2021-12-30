import '../constants/mybutton.dart';
import 'dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class StakeSuccess extends StatefulWidget {
  const StakeSuccess({Key? key}) : super(key: key);

  static const routename = '/stake-success';

  @override
  State<StakeSuccess> createState() => _StakeSuccessState();
}

class _StakeSuccessState extends State<StakeSuccess> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    final successData = ModalRoute.of(context)!.settings.arguments as Map;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(children: [
              SizedBox(
                height: 20,
              ),
              ConfettiWidget(
                blastDirectionality: BlastDirectionality.explosive,
                confettiController: _controller,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 100,
                gravity: 0.05,
                shouldLoop: false,
                colors: [
                  Colors.green,
                  Colors.red,
                  Colors.yellow,
                  Colors.blue,
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/images/animaton.png",
                  scale: 3,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(8),
              //   child: Text('Congratulations',
              //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'You have successfully staked ${successData['numberOfCoins']} CNL',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff1A22FF),
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Order Id : ',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        ' ${successData['order_id']}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Staking Bonus : ',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '${successData['intrest_rate']}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Staking End Date : ',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '${successData['maturity_date']}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                child: MyButton(text: 'OK'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen()));
                  // Navigator.of(context).pop();
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
