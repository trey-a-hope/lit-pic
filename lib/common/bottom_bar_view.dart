// import 'package:flutter/material.dart';
// import 'package:litpic/constants.dart';
// import 'dart:math' as math;
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// class BottomBarView extends StatefulWidget {
//   final Function(int index) changeIndex;
//   final Function addClick;
//   // final List<TabIconData> tabIconsList;
//   const BottomBarView(
//       { //required this.tabIconsList,
//       required this.changeIndex,
//       required this.addClick})
//       : super();
//   @override
//   _BottomBarViewState createState() => _BottomBarViewState();
// }

// class _BottomBarViewState extends State<BottomBarView>
//     with TickerProviderStateMixin {
//   late final AnimationController animationController;

//   PersistentTabController _controller =
//       PersistentTabController(initialIndex: 0);

//   @override
//   void initState() {
//     animationController = new AnimationController(
//       vsync: this,
//       duration: new Duration(milliseconds: 1000),
//     );
//     animationController.forward();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: [
//         Container(
//           color: Colors.red,
//         ),
//         Container(
//           color: Colors.black,
//         ),
//         Container(
//           color: Colors.blue,
//         )
//       ],
//       items: [
//         PersistentBottomNavBarItem(
//             icon: Icon(Icons.add),
//             title: ("Delete"),
//             activeColorPrimary: Colors.blueAccent,
//             activeColorSecondary: Colors.white,
//             inactiveColorPrimary: Colors.white,
//             // routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             //   initialRoute: '/',
//             //   routes: {
//             //     '/first': (context) => MainScreen2(),
//             //     '/second': (context) => MainScreen3(),
//             //   },
//             // ),
//             onPressed: (context) {
//               // pushDynamicScreen(context,
//               //     screen: SampleModalScreen(), withNavBar: true);
//             }),
//         PersistentBottomNavBarItem(
//             icon: Icon(Icons.add),
//             title: ("Add"),
//             activeColorPrimary: Colors.blueAccent,
//             activeColorSecondary: Colors.white,
//             inactiveColorPrimary: Colors.white,
//             // routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             //   initialRoute: '/',
//             //   routes: {
//             //     '/first': (context) => MainScreen2(),
//             //     '/second': (context) => MainScreen3(),
//             //   },
//             // ),
//             onPressed: (context) {
//               // pushDynamicScreen(context,
//               //     screen: SampleModalScreen(), withNavBar: true);
//             }),
//         PersistentBottomNavBarItem(
//             icon: Icon(Icons.add),
//             title: ("Add"),
//             activeColorPrimary: Colors.blueAccent,
//             activeColorSecondary: Colors.white,
//             inactiveColorPrimary: Colors.white,
//             // routeAndNavigatorSettings: RouteAndNavigatorSettings(
//             //   initialRoute: '/',
//             //   routes: {
//             //     '/first': (context) => MainScreen2(),
//             //     '/second': (context) => MainScreen3(),
//             //   },
//             // ),
//             onPressed: (context) {
//               // pushDynamicScreen(context,
//               //     screen: SampleModalScreen(), withNavBar: true);
//             }),
//       ],
//       confineInSafeArea: true,
//       backgroundColor: Colors.white,
//       handleAndroidBackButtonPress: true,
//       resizeToAvoidBottomInset: true,
//       stateManagement: true,
//       navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
//           ? 0.0
//           : kBottomNavigationBarHeight,
//       hideNavigationBarWhenKeyboardShows: true,
//       margin: EdgeInsets.all(0.0),
//       popActionScreens: PopActionScreensType.all,
//       bottomScreenMargin: 0.0,
//       onWillPop: (context) async {
//         // await showDialog(
//         //   context: context,
//         //   useSafeArea: true,
//         //   builder: (context) => Container(
//         //     height: 50.0,
//         //     width: 50.0,
//         //     color: Colors.white,
//         //     child: ElevatedButton(
//         //       child: Text("Close"),
//         //       onPressed: () {
//         //         Navigator.pop(context);
//         //       },
//         //     ),
//         //   ),
//         // );
//         return true;
//       },
//       selectedTabScreenContext: (context) {
//         // testContext = context;
//       },
//       // hideNavigationBar: _hideNavBar,
//       decoration: NavBarDecoration(
//           colorBehindNavBar: Colors.indigo,
//           borderRadius: BorderRadius.circular(20.0)),
//       popAllScreensOnTapOfSelectedTab: true,
//       itemAnimationProperties: ItemAnimationProperties(
//         duration: Duration(milliseconds: 400),
//         curve: Curves.ease,
//       ),
//       screenTransitionAnimation: ScreenTransitionAnimation(
//         animateTabTransition: true,
//         curve: Curves.ease,
//         duration: Duration(milliseconds: 200),
//       ),
//       navBarStyle:
//           NavBarStyle.style10, // Choose the nav bar style with this property
//     );
//     // return Stack(
//     //   alignment: AlignmentDirectional.bottomCenter,
//     //   children: <Widget>[
//     //     AnimatedBuilder(
//     //       animation: animationController,
//     //       builder: (BuildContext context, Widget? child) {
//     //         TabIconData homeTabIconData = TabIconData(
//     //           unselectedIcon: Icon(
//     //             Icons.home,
//     //             color: Colors.grey,
//     //           ),
//     //           selectedIcon: Icon(
//     //             Icons.home,
//     //             color: Colors.amber,
//     //           ),
//     //           index: 0,
//     //           isSelected: true,
//     //           animationController: animationController,
//     //         );

//     //         TabIconData editTabIconData = TabIconData(
//     //           unselectedIcon: Icon(
//     //             Icons.edit,
//     //             color: Colors.grey,
//     //           ),
//     //           selectedIcon: Icon(
//     //             Icons.edit,
//     //             color: Colors.amber,
//     //           ),
//     //           index: 1,
//     //           isSelected: false,
//     //           animationController: animationController,
//     //         );

//     //         TabIconData shoppingCartTabIconData = TabIconData(
//     //           unselectedIcon: Icon(
//     //             Icons.shopping_cart,
//     //             color: Colors.grey,
//     //           ),
//     //           selectedIcon: Icon(
//     //             Icons.shopping_cart,
//     //             color: Colors.amber,
//     //           ),
//     //           index: 2,
//     //           isSelected: false,
//     //           animationController: animationController,
//     //         );

//     //         TabIconData faceTabIconData = TabIconData(
//     //           unselectedIcon: Icon(
//     //             Icons.face,
//     //             color: Colors.grey,
//     //           ),
//     //           selectedIcon: Icon(
//     //             Icons.face,
//     //             color: Colors.amber,
//     //           ),
//     //           index: 3,
//     //           isSelected: false,
//     //           animationController: animationController,
//     //         );

//     //         TabIconData settingsTabIconData = TabIconData(
//     //           unselectedIcon: Icon(
//     //             Icons.settings,
//     //             color: Colors.grey,
//     //           ),
//     //           selectedIcon: Icon(
//     //             Icons.settings,
//     //             color: Colors.amber,
//     //           ),
//     //           index: 4,
//     //           isSelected: false,
//     //           animationController: animationController,
//     //         );

//     //         return Transform(
//     //           transform: Matrix4.translationValues(0.0, 0.0, 0.0),
//     //           child: PhysicalShape(
//     //             color: LitPicTheme.white,
//     //             elevation: 16.0,
//     //             clipper: TabClipper(
//     //                 radius: Tween(begin: 0.0, end: 0.0)
//     //                         .animate(CurvedAnimation(
//     //                             parent: animationController,
//     //                             curve: Curves.fastOutSlowIn))
//     //                         .value *
//     //                     38.0),
//     //             child: Column(
//     //               children: <Widget>[
//     //                 SizedBox(
//     //                   height: 52,
//     //                   child: Row(
//     //                     children: <Widget>[
//     //                       Expanded(
//     //                         child: TabIcon(
//     //                           tabIconData: homeTabIconData,
//     //                           removeAllSelect: () {
//     //                             toggleTabIconData(
//     //                               tabIconData: homeTabIconData,
//     //                               index: 0,
//     //                             );
//     //                             widget.changeIndex(0);
//     //                           },
//     //                         ),
//     //                       ),
//     //                       Expanded(
//     //                         child: TabIcon(
//     //                           tabIconData: editTabIconData,
//     //                           removeAllSelect: () {
//     //                             toggleTabIconData(
//     //                               tabIconData: editTabIconData,
//     //                               index: 1,
//     //                             );
//     //                             widget.changeIndex(1);
//     //                           },
//     //                         ),
//     //                       ),
//     //                       Expanded(
//     //                         child: TabIcon(
//     //                           tabIconData: shoppingCartTabIconData,
//     //                           removeAllSelect: () {
//     //                             toggleTabIconData(
//     //                               tabIconData: shoppingCartTabIconData,
//     //                               index: 2,
//     //                             );
//     //                             widget.changeIndex(2);
//     //                           },
//     //                         ),
//     //                       ),
//     //                       Expanded(
//     //                         child: TabIcon(
//     //                           tabIconData: faceTabIconData,
//     //                           removeAllSelect: () {
//     //                             toggleTabIconData(
//     //                               tabIconData: shoppingCartTabIconData,
//     //                               index: 3,
//     //                             );
//     //                             widget.changeIndex(3);
//     //                           },
//     //                         ),
//     //                       ),
//     //                       Expanded(
//     //                         child: TabIcon(
//     //                           tabIconData: settingsTabIconData,
//     //                           removeAllSelect: () {
//     //                             toggleTabIconData(
//     //                               tabIconData: shoppingCartTabIconData,
//     //                               index: 4,
//     //                             );
//     //                             widget.changeIndex(4);
//     //                           },
//     //                         ),
//     //                       ),
//     //                     ],
//     //                   ),
//     //                 ),
//     //                 SizedBox(
//     //                   height: MediaQuery.of(context).padding.bottom,
//     //                 )
//     //               ],
//     //             ),
//     //           ),
//     //         );
//     //       },
//     //     ),
//     //   ],
//     // );
//   }

//   void toggleTabIconData(
//       {required TabIconData tabIconData, required int index}) {
//     if (!mounted) return;

//     setState(() {
//       tabIconData.isSelected = tabIconData.index == index;
//     });
//   }
// }

// class TabClipper extends CustomClipper<Path> {
//   final double radius;
//   TabClipper({this.radius = 38.0});

//   @override
//   Path getClip(Size size) {
//     final path = Path();

//     final v = radius * 2;
//     path.lineTo(0, 0);
//     path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
//         degreeToRadians(90), false);
//     path.arcTo(
//         Rect.fromLTWH(
//             ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
//         degreeToRadians(270),
//         degreeToRadians(70),
//         false);

//     path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
//         degreeToRadians(160), degreeToRadians(-140), false);

//     path.arcTo(
//         Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
//             radius, radius),
//         degreeToRadians(200),
//         degreeToRadians(70),
//         false);
//     path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
//         degreeToRadians(270), degreeToRadians(90), false);
//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);

//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(TabClipper oldClipper) => true;

//   double degreeToRadians(double degree) {
//     var redian = (math.pi / 180) * degree;
//     return redian;
//   }
// }
