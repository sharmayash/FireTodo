import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

import './TabScreen.dart';
import './splash_screen.dart';
import './auth/LogInScreen.dart';
import './auth/SignUpScreen.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var auth;
  @override
  void didChangeDependencies() {
    auth = Provider.of<Auth>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return auth.isAuth
        ? TabScreen()
        : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen("Loading")
                    : SafeArea(
                        child: Scaffold(
                          body: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                stops: [0.1, 0.4, 0.6, 0.9],
                                colors: [
                                  Colors.yellow[100],
                                  Colors.red[50],
                                  Colors.indigo[50],
                                  Colors.teal[100]
                                ],
                              ),
                            ),
                            height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.fromLTRB(0, 150, 0, 200),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Welcome To Firetodo",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(LogInScreen.routeName);
                                      },
                                      child: Text("Login"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.0, vertical: 16.0),
                                      color: Colors.indigo[100],
                                    ),
                                    Text("OR"),
                                    RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(SignUpScreen.routeName);
                                      },
                                      child: Text("Sign Up"),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.0, vertical: 16.0),
                                      color: Colors.indigo[100],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          );
  }
}
