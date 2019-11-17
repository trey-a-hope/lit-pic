import 'package:flutter/material.dart';

final String testSecretKey = 'sk_test_6s03VnuOvJtDW7a6ygpFdDdM00Jxr17MUX';
final String testPublishableKey = 'pk_test_E2jn7tAPmhIlGYM2rg1hzQWc00DAPdLu9K';
final String liveSecretKey = '?';
final String livePublishableKey = '?';
final String endpoint =
    'https://us-central1-hidden-gems-e481d.cloudfunctions.net/';

class LithophanesData {
  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  int kacl;

  LithophanesData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = "",
    this.endColor = "",
    this.meals,
    this.kacl = 0,
  });

  static List<LithophanesData> tabIconsList = [
    LithophanesData(
      imagePath: 'assets/images/ankhti.png',
      titleTxt: 'Ankhti & Family',
      kacl: 45,
      meals: ["6in x 7in,", "White PLA"],
      startColor: "#FA7D82",
      endColor: "#FFB295",
    ),
    LithophanesData(
      imagePath: 'assets/images/sza.png',
      titleTxt: 'SZA',
      kacl: 50,
      meals: ["8in x 6in,", "White PLA"],
      startColor: "#738AE6",
      endColor: "#5C5EDD",
    ),

    LithophanesData(
      imagePath: 'assets/images/mlk.png',
      titleTxt: 'MLK',
      kacl: 42,
      meals: ["8in x 4.5in,", "Red PLA"],
      startColor: "#FE95B6",
      endColor: "#FF5287",
    ),
    // MealsListData(
    //   imagePath: 'assets/fitness_app/dinner.png',
    //   titleTxt: 'Dinner',
    //   kacl: 0,
    //   meals: ["Recommend:", "703 kcal"],
    //   startColor: "#6F72CA",
    //   endColor: "#1E1466",
    // ),
  ];
}

class TabIconData {
  // String imagePath;
  // String selctedImagePath;
  Icon unselectedIcon;
  Icon selectedIcon;
  bool isSelected;
  int index;
  AnimationController animationController;

  TabIconData({
    // this.imagePath = '',
    this.index = 0,
    // this.selctedImagePath = "",
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
      // imagePath: 'assets/fitness_app/tab_1.png',
      // selctedImagePath: 'assets/fitness_app/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      unselectedIcon: Icon(
        Icons.image,
        color: Colors.grey,
      ),
      selectedIcon: Icon(
        Icons.image,
        color: Colors.amber,
      ),
      // imagePath: 'assets/fitness_app/tab_2.png',
      // selctedImagePath: 'assets/fitness_app/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      // imagePath: 'assets/fitness_app/tab_3.png',
      // selctedImagePath: 'assets/fitness_app/tab_3s.png',
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
      // imagePath: 'assets/fitness_app/tab_4.png',
      // selctedImagePath: 'assets/fitness_app/tab_4s.png',
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
      // imagePath: 'assets/fitness_app/tab_4.png',
      // selctedImagePath: 'assets/fitness_app/tab_4s.png',
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
