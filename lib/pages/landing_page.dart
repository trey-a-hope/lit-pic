// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get_it/get_it.dart';
// import 'package:litpic/common/simple_navbar.dart';
// import 'package:litpic/pages/home_page.dart';
// import 'package:litpic/services/auth.dart';
// import 'package:simple_animations/simple_animations.dart';

// class LandingPage extends StatefulWidget {
//   @override
//   State createState() => LandingPageState();
// }

// class LandingPageState extends State<LandingPage>
//     with SingleTickerProviderStateMixin {
//   FirebaseUser user;
//   final GetIt getIt = GetIt.I;

//   @override
//   void initState() {
//     super.initState();

//     getIt<Auth>().onAuthStateChanged().listen(
//       (firebaseUser) {
//         setState(
//           () {
//             user = firebaseUser;
//             if (user != null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => HomePage(),
//                 ),
//               );
//             }
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: <Widget>[
//           SimpleNavbar(
//             leftWidget: Text(
//               'Login',
//               style: TextStyle(fontSize: 15),
//             ),
//             leftTap: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => LoginPage(),
//               //   ),
//               // );
//             },
//             rightWidget: Text(
//               'Sign Up',
//               style: TextStyle(fontSize: 15),
//             ),
//             rightTap: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => SignUpPage(),
//               //   ),
//               // );
//             },
//           ),
//           Center(
//             child: Text("Hello")
//           ),
//           // SafeArea(
//           //   child: Center(
//           //     child: buildAnimation(),
//           //   ),
//           // ),
//           Positioned(
//             bottom: 100,
//             left: 0,
//             right: 0,
//             child: Text('Feelings Unleashed',
//                 style: TextStyle(
//                     color: Color(0xff757575),
//                     fontStyle: FontStyle.normal,
//                     fontSize: 25.0),
//                 textAlign: TextAlign.center),
//           ),
//         ],
//       ),
//     );
//   }

//   final tween = MultiTrackTween(
//     [
//       Track("translateY")
//           .add(Duration(seconds: 1), Tween(begin: -100.0, end: 0.0)),
//       Track("scale")
//           .add(Duration(seconds: 1), ConstantTween(1.0))
//           .add(Duration(seconds: 1), Tween(begin: 1.0, end: 0.0)),
//     ],
//   ); //.animate(controller);

//   Widget buildAnimation() {
//     return ControlledAnimation(
//       playback: Playback.MIRROR,
//       duration: tween.duration,
//       tween: tween,
//       builder: (context, animation) {
//         return Transform.rotate(
//           angle: animation["rotation"],
//           child: Container(
//             width: animation["size"],
//             height: animation["size"],
//             color: animation["color"],
//           ),
//         );
//       },
//     );
//   }
// }
