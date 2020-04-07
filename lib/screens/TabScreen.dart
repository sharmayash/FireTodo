import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './FavPage.dart';
import './NewTodo.dart';
import './HomePage.dart';
import './splash_screen.dart';

import '../provider/auth.dart';
import '../provider/todos.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Widget> _pages;
  bool _isInit = true;
  bool _isLoading = false;
  int _selectedPageIndex = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
        _pages = [
          _isLoading ? SplashScreen("Getting Your Todos") : HomePage(),
          NewTodo(),
          _isLoading ? SplashScreen("Getting Your Fav. Todos") : FavPage(),
        ];
      });

      Provider.of<Todos>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
          _pages = [
            _isLoading ? SplashScreen("Getting Your Todos") : HomePage(),
            NewTodo(),
            _isLoading ? SplashScreen("Getting Your Fav. Todos") : FavPage()
          ];
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fire Your Todos"),
        backgroundColor: Colors.blueGrey[900],
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            child: Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.green),
                title: Text("Home"),
                backgroundColor: Colors.blueGrey[900],
                activeIcon: Icon(Icons.dashboard, color: Colors.green[200])),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline, color: Colors.purple),
                title: Text("New Todo"),
                backgroundColor: Colors.blueGrey[900],
                activeIcon: Icon(Icons.add_circle, color: Colors.purple[200])),
            BottomNavigationBarItem(
                icon: Icon(Icons.star_border, color: Colors.yellow),
                title: Text("Favourites"),
                backgroundColor: Colors.blueGrey[900],
                activeIcon: Icon(Icons.star, color: Colors.yellow[200])),
          ]),
    );
  }
}
