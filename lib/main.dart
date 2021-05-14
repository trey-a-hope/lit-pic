import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:litpic/blocs/cart/cart_bloc.dart' as CART_BP;
import 'package:litpic/blocs/login/login_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:litpic/common/bottom_bar_view.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/pages/home_page.dart';
import 'package:litpic/pages/settings_page.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:package_info/package_info.dart';
import 'blocs/create_lithophane/create_lithophane_bloc.dart' as CREATE_BP;
import 'blocs/profile/profile_bloc.dart' as PROFILE_BP;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  if (Platform.isAndroid) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  } else {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
  }

  //Make status bar in Android transparent.
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  setUpLocater();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  runApp(
    Phoenix(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lit Pic',
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: Colors.black,
        primaryColor: Colors.black,
        fontFamily: 'Montserrat',
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: locator<AuthService>().onAuthStateChanged(),
      builder: (context, snapshot) {
        User user = snapshot.data;
        return user == null
            ? BlocProvider(
                create: (context) => LoginBloc(),
                child: LoginPage(),
              )
            : MainApp();
      },
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: LitPicTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    tabBody = HomePage(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LitPicTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            tabBody,
            bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (index) {
            switch (index) {
              case 0:
                animationController.reverse().then((data) {
                  if (!mounted) return;
                  setState(() {
                    tabBody =
                        HomePage(animationController: animationController);
                  });
                });
                break;
              case 1:
                animationController.reverse().then(
                  (data) {
                    if (!mounted) return;
                    setState(
                      () {
                        tabBody = BlocProvider(
                          lazy: true,
                          create: (context) => CREATE_BP.CreateLithophaneBloc()
                            ..add(CREATE_BP.LoadPageEvent()),
                          child: CREATE_BP.CreateLithophanePage(),
                        );
                      },
                    );
                  },
                );
                break;
              case 2:
                animationController.reverse().then((data) {
                  if (!mounted) return;
                  setState(() {
                    tabBody = BlocProvider(
                      lazy: true,
                      create: (context) =>
                          CART_BP.CartBloc()..add(CART_BP.LoadPageEvent()),
                      child: CART_BP.CartPage(),
                    );
                  });
                });
                break;
              case 3:
                animationController.reverse().then((data) {
                  if (!mounted) return;
                  setState(() {
                    tabBody = BlocProvider(
                      lazy: true,
                      create: (context) => PROFILE_BP.ProfileBloc()
                        ..add(PROFILE_BP.LoadPageEvent()),
                      child: PROFILE_BP.ProfilePage(),
                    );
                  });
                });
                break;
              case 4:
                animationController.reverse().then((data) {
                  if (!mounted) return;
                  setState(() {
                    tabBody =
                        SettingsPage(animationController: animationController);
                  });
                });
                break;
            }
          },
        ),
      ],
    );
  }
}
