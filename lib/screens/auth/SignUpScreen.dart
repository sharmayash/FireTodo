import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './LogInScreen.dart';

import '../../provider/auth.dart';
import '../../models/HttpException.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  const SignUpScreen({
    Key key,
  }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submitSignUp() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();

    try {
      await Provider.of<Auth>(context, listen: false)
          .signup(_authData['email'], _authData['password'])
          .then((value) =>
              Navigator.of(context).popUntil(ModalRoute.withName("/")));
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Welcome to FireTodo",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 250,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepPurpleAccent, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none, labelText: 'E-Mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return (value.isEmpty || !value.contains('@'))
                              ? "Check Your Email"
                              : null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value;
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      margin: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepPurpleAccent, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none, labelText: 'Password'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          return (value.isEmpty || value.length < 6)
                              ? 'Password is too short!'
                              : null;
                        },
                        onSaved: (value) {
                          _authData['password'] = value;
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      margin: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.deepPurpleAccent, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        // controller: _passwordController,
                        validator: (value) {
                          return (value != _passwordController.text)
                              ? 'Password do not match!'
                              : null;
                        },
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                        child: RaisedButton(
                            child: Text("Sign Up"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 16.0),
                            color: Colors.blueGrey[200],
                            onPressed: _submitSignUp)),
                    FlatButton(
                        onPressed: () {
                          Navigator.popAndPushNamed(
                              context, LogInScreen.routeName);
                        },
                        child: Text(
                          "Already A User? Log In Here",
                          style: TextStyle(color: Colors.blueGrey),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
