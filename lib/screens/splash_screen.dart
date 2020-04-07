import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatelessWidget {
  final String message;

  SplashScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[800],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitChasingDots(
              color: Colors.white,
              size: 40.0,
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  this.message,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                )),
          ],
        ));
  }
}
