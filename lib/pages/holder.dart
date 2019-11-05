import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/pages/home_page.dart';
import 'package:litpic/pages/profile_page.dart';
import 'package:litpic/pages/settings_page.dart';
import 'package:litpic/pages/shop/cart_page.dart';
import 'package:litpic/pages/shop/shop_page.dart';
import 'package:litpic/services/modal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Holder extends StatefulWidget {
  @override
  State createState() => HolderState();
}

class HolderState extends State<Holder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  final GetIt getIt = GetIt.I;

  final List<String> _titles = [
    'Lit Pic',
    'Shop',
    'Cart',
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
      child: ShopPage(),
    ),
    Container(
      color: Colors.purpleAccent,
      child: CartPage(),
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
    Colors.purpleAccent,
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
        leading: _currentIndex == 3
            ? IconButton(icon: Icon(Icons.message), onPressed: () {
                    getIt<Modal>().showAlert(
                        context: context,
                        title: 'To Do',
                        message: 'Open Messages');
                  },)
            : Container(),
        centerTitle: true,
        title: Text(
          _titles[_currentIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          _currentIndex == 3
              ? IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    getIt<Modal>().showAlert(
                        context: context,
                        title: 'To Do',
                        message: 'Open Edit Profile');
                  },
                )
              : Container(),
        ],
      ),
      body: _children[_currentIndex],
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.white,
        color: Colors.black,
        backgroundColor: _colors[_currentIndex],
        items: <Widget>[
          //           GestureDetector(
          //   child: Icon(
          //     MdiIcons.home,
          //     color: _currentIndex == 0 ? _colors[_currentIndex] : Colors.white,
          //   ),
          //   onTap: () => _currentIndex = 1,
          // ),
          Icon(
            MdiIcons.home,
            color: _currentIndex == 0 ? _colors[_currentIndex] : Colors.white,
          ),
          Icon(
            Icons.image,
            color: _currentIndex == 1 ? _colors[_currentIndex] : Colors.white,
          ),
          Icon(
            Icons.shopping_cart,
            color: _currentIndex == 2 ? _colors[_currentIndex] : Colors.white,
          ),
          Icon(
            Icons.face,
            color: _currentIndex == 3 ? _colors[_currentIndex] : Colors.white,
          ),
          Icon(
            Icons.settings,
            color: _currentIndex == 4 ? _colors[_currentIndex] : Colors.white,
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