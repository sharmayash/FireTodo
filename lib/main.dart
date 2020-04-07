import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './provider/auth.dart';
import './provider/todos.dart';

import './screens/Welcome.dart';
import './screens/HomePage.dart';
import './screens/auth/LogInScreen.dart';
import './screens/auth/SignUpScreen.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Todos>(
          update: (ctx, auth, previousTodos) => Todos(
            auth.token,
            auth.userId,
            previousTodos == null ? [] : previousTodos.todoList,
          ),
          create: (BuildContext ctx) {},
        )
      ],
      child: MaterialApp(
        title: 'FireTodo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Welcome(),
        routes: {
          HomePage.routeName: (ctx) => HomePage(),
          LogInScreen.routeName: (ctx) => LogInScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen()
        },
      ),
    );
  }
}
