import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:litpic/blocs/cart/cart_bloc.dart' as CART_BP;
import 'package:litpic/blocs/login/login_bloc.dart';
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
  late final User? user;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: locator<AuthService>().onAuthStateChanged(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainApp();
        }

        return BlocProvider(
          create: (context) => LoginBloc(),
          child: LoginPage(),
        );
      },
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  int _tabIndex = 0;

  Color _homeActiveColor = Colors.amber;
  Color _homeInactiveColor = LitPicTheme.nearlyDarkBlue;
  Color _createActiveColor = LitPicTheme.nearlyDarkBlue;
  Color _createInactiveColor = Colors.amber;
  Color _cartActiveColor = LitPicTheme.nearlyDarkBlue;
  Color _cartInactiveColor = Colors.amber;
  Color _profileActiveColor = LitPicTheme.nearlyDarkBlue;
  Color _profileInactiveColor = Colors.amber;
  Color _settingsActiveColor = LitPicTheme.nearlyDarkBlue;
  Color _settingsInactiveColor = Colors.amber;

  Widget tabBody = HomePage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
            // bottomBar(),
          ],
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _tabIndex,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          onItemSelected: (index) {
            setState(() {
              _tabIndex = index;

              _homeActiveColor =
                  _tabIndex == 0 ? Colors.amber : LitPicTheme.nearlyDarkBlue;
              _homeInactiveColor =
                  _tabIndex == 0 ? LitPicTheme.nearlyDarkBlue : Colors.amber;

              _createActiveColor =
                  _tabIndex == 1 ? Colors.amber : LitPicTheme.nearlyDarkBlue;
              _createInactiveColor =
                  _tabIndex == 1 ? LitPicTheme.nearlyDarkBlue : Colors.amber;

              _cartActiveColor =
                  _tabIndex == 2 ? Colors.amber : LitPicTheme.nearlyDarkBlue;
              _cartInactiveColor =
                  _tabIndex == 2 ? LitPicTheme.nearlyDarkBlue : Colors.amber;

              _profileActiveColor =
                  _tabIndex == 3 ? Colors.amber : LitPicTheme.nearlyDarkBlue;
              _profileInactiveColor =
                  _tabIndex == 3 ? LitPicTheme.nearlyDarkBlue : Colors.amber;

              _settingsActiveColor =
                  _tabIndex == 4 ? Colors.amber : LitPicTheme.nearlyDarkBlue;
              _settingsInactiveColor =
                  _tabIndex == 4 ? LitPicTheme.nearlyDarkBlue : Colors.amber;

              switch (index) {
                case 0:
                  tabBody = HomePage();
                  break;
                case 1:
                  tabBody = BlocProvider(
                    lazy: true,
                    create: (context) => CREATE_BP.CreateLithophaneBloc()
                      ..add(CREATE_BP.LoadPageEvent()),
                    child: CREATE_BP.CreateLithophanePage(),
                  );

                  break;
                case 2:
                  tabBody = BlocProvider(
                    lazy: true,
                    create: (context) =>
                        CART_BP.CartBloc()..add(CART_BP.LoadPageEvent()),
                    child: CART_BP.CartPage(),
                  );
                  break;
                case 3:
                  tabBody = BlocProvider(
                    lazy: true,
                    create: (context) => PROFILE_BP.ProfileBloc()
                      ..add(PROFILE_BP.LoadPageEvent()),
                    child: PROFILE_BP.ProfilePage(),
                  );
                  break;
                case 4:
                  tabBody = SettingsPage();
                  break;
                default:
                  break;
              }
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(
                Icons.home,
                color: _homeInactiveColor,
              ),
              title: Text(
                'Home',
                style: TextStyle(color: _homeInactiveColor),
              ),
              activeColor: _homeActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.add,
                color: _createInactiveColor,
              ),
              title: Text(
                'Create',
                style: TextStyle(color: _createInactiveColor),
              ),
              activeColor: _createActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: _cartInactiveColor,
              ),
              title: Text(
                'Cart',
                style: TextStyle(color: _cartInactiveColor),
              ),
              activeColor: _cartActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.face,
                color: _profileInactiveColor,
              ),
              title: Text(
                'Profile',
                style: TextStyle(color: _profileInactiveColor),
              ),
              activeColor: _profileActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.settings,
                color: _settingsInactiveColor,
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: _settingsInactiveColor),
              ),
              activeColor: _settingsActiveColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
