import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:litpic/pages/home_page.dart';
import 'package:litpic/pages/profile_page.dart';
import 'package:litpic/pages/settings_page.dart';
import 'package:litpic/pages/shop/shopping_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Holder extends StatefulWidget {
  @override
  State createState() => HolderState();
}

class HolderState extends State<Holder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final List<String> _titles = [
    'Lit Pic',
    'Shopping',
    'Profile',
    'Settings'
  ];

  final List<Widget> _children = [
    Container(
      color: Colors.red,
      child: HomePage(),
    ),
    Container(
      color: Colors.blue,
      child: ShoppingPage(),
    ),
    Container(
      color: Colors.cyan,
      child: ProfilePage(),
    ),
    Container(
      color: Colors.green,
      child: SettingsPage(),
    ),
  ];

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.cyan,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
           _titles[_currentIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _children[_currentIndex],
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.white,
        color: Colors.black,
        backgroundColor: _colors[_currentIndex],
        items: <Widget>[
          Icon(
            MdiIcons.home,
            color: _currentIndex == 0 ? _colors[_currentIndex] : Colors.white,
          ),
          Icon(
            Icons.shop,
            color: _currentIndex == 1 ? _colors[_currentIndex] : Colors.white,
          ),
          Icon(
            Icons.face,
            color: _currentIndex == 2 ? _colors[_currentIndex] : Colors.white,
          ),
          Icon(
            Icons.settings,
            color: _currentIndex == 3 ? _colors[_currentIndex] : Colors.white,
          )
        ],
        onTap: (index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
        },
      ),
    );
  }
}
