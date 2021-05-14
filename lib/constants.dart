import 'package:flutter/material.dart';
import 'extensions/hexcolor.dart';

const String GCF_ENDPOINT =
    'https://us-central1-litpic-f293c.cloudfunctions.net/';

const String SKU_UD = 'sku_GATEGxr1FwZMJQ';
const String ADMIN_DOC_ID = 'jFPx3bn9asN7UlIaWSlVi9W37bh2';

//These are set in main().
String version;
String buildNumber;
double screenWidth;
double screenHeight;

class TabIconData {
  Icon unselectedIcon;
  Icon selectedIcon;
  bool isSelected;
  int index;
  AnimationController animationController;

  TabIconData({
    this.index = 0,
    this.unselectedIcon,
    this.selectedIcon,
    this.isSelected = false,
    this.animationController,
  });

  static List<TabIconData> tabIconsList = [
    TabIconData(
      unselectedIcon: Icon(
        Icons.home,
        color: Colors.grey,
      ),
      selectedIcon: Icon(
        Icons.home,
        color: Colors.amber,
      ),
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      unselectedIcon: Icon(
        Icons.edit,
        color: Colors.grey,
      ),
      selectedIcon: Icon(
        Icons.edit,
        color: Colors.amber,
      ),
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      unselectedIcon: Icon(
        Icons.shopping_cart,
        color: Colors.grey,
      ),
      selectedIcon: Icon(
        Icons.shopping_cart,
        color: Colors.amber,
      ),
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      unselectedIcon: Icon(
        Icons.face,
        color: Colors.grey,
      ),
      selectedIcon: Icon(
        Icons.face,
        color: Colors.amber,
      ),
      index: 3,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      unselectedIcon: Icon(
        Icons.settings,
        color: Colors.grey,
      ),
      selectedIcon: Icon(
        Icons.settings,
        color: Colors.amber,
      ),
      index: 4,
      isSelected: false,
      animationController: null,
    ),
  ];
}

final List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

final List<String> unitedStates = [
  "AK",
  "AL",
  "AR",
  "AS",
  "AZ",
  "CA",
  "CO",
  "CT",
  "DC",
  "DE",
  "FL",
  "GA",
  "GU",
  "HI",
  "IA",
  "ID",
  "IL",
  "IN",
  "KS",
  "KY",
  "LA",
  "MA",
  "MD",
  "ME",
  "MI",
  "MN",
  "MO",
  "MS",
  "MT",
  "NC",
  "ND",
  "NE",
  "NH",
  "NJ",
  "NM",
  "NV",
  "NY",
  "OH",
  "OK",
  "OR",
  "PA",
  "PR",
  "RI",
  "SC",
  "SD",
  "TN",
  "TX",
  "UT",
  "VA",
  "VI",
  "VT",
  "WA",
  "WI",
  "WV",
  "WY"
];

final List<ColorName> filamentColors = [
  ColorName(name: 'White', color: Colors.white),
  ColorName(name: 'Blue', color: HexColor('#000080')),
  ColorName(name: 'Black', color: Colors.black),
  ColorName(name: 'Brown', color: Colors.brown),
  ColorName(name: 'Green', color: Colors.green[700]),
  ColorName(name: 'Light Green', color: Colors.lightGreen[400]),
  ColorName(name: 'Grey', color: Colors.grey),
  ColorName(name: 'Pink', color: Colors.pink),
  ColorName(name: 'Purple', color: Colors.purple),
  ColorName(name: 'Magenta', color: HexColor('#ff00ff')),
  ColorName(name: 'Orange', color: Colors.orange),
  ColorName(name: 'Yellow', color: Colors.yellow),
  ColorName(name: 'Red', color: Colors.red),
  ColorName(name: 'Light Blue', color: Colors.lightBlue),
  ColorName(
    name: 'Gold',
    color: HexColor('#d4af37'),
  ),
];

class ColorName {
  final String name;
  final Color color;

  ColorName({@required this.name, @required this.color});
}
