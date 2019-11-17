import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/bottom_bar_view.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/pages/authentication/login_page.dart';
import 'package:litpic/pages/cart_page_new.dart';
import 'package:litpic/pages/home_page.dart';
import 'package:litpic/pages/profile_page_new.dart';
import 'package:litpic/pages/settings_page_new.dart';
import 'package:litpic/pages/shop_page_new.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/device_service.dart';
import 'package:litpic/services/fcm_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/image_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe/card.dart';
import 'package:litpic/services/stripe/charge.dart';
import 'package:litpic/services/stripe/coupon.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/stripe/token.dart';
import 'package:litpic/services/validater_service.dart';

final GetIt getIt = GetIt.instance;

void main() {
  //Make status bar in Android transparent.
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();

  //Authentication
  getIt.registerSingleton<AuthService>(AuthServiceImplementation(),
      signalsReady: true);
  //Database
  getIt.registerSingleton<DBService>(DBServiceImplementation(),
      signalsReady: true);
  //Firebase Cloud Messaging
  getIt.registerSingleton<FCMService>(FCMServiceImplementation(),
      signalsReady: true);
  //Formatter
  getIt.registerSingleton<FormatterService>(FormatterServiceImplementation(),
      signalsReady: true);
  //Image
  getIt.registerSingleton<ImageService>(ImageServiceImplementation(),
      signalsReady: true);
  //Modal
  getIt.registerSingleton<ModalService>(ModalServiceImplementation(),
      signalsReady: true);
  //Package Device Info
  getIt.registerSingleton<DeviceService>(DeviceServiceImplementation(),
      signalsReady: true);
  //Storage
  getIt.registerSingleton<StorageService>(StorageServiceImplementation(),
      signalsReady: true);
  //Stripe Card
  getIt.registerSingleton<StripeCard>(
      StripeCardImplementation(apiKey: testSecretKey, endpoint: endpoint),
      signalsReady: true);
  //Stripe Charge
  getIt.registerSingleton<StripeCharge>(
      StripeChargeImplementation(apiKey: testSecretKey, endpoint: endpoint),
      signalsReady: true);
  //Stripe Customer
  getIt.registerSingleton<StripeCustomer>(
      StripeCustomerImplementation(apiKey: testSecretKey, endpoint: endpoint),
      signalsReady: true);
  //Stripe Coupon
  getIt.registerSingleton<StripeCoupon>(
      StripeCouponImplementation(apiKey: testSecretKey, endpoint: endpoint),
      signalsReady: true);
  //Stripe Token
  getIt.registerSingleton<StripeToken>(
      StripeTokenImplementation(apiKey: testSecretKey, endpoint: endpoint),
      signalsReady: true);
  //Validator
  getIt.registerSingleton<ValidatorService>(ValidatorServiceImplementation(),
      signalsReady: true);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );

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
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          return user == null ? LoginPage() : FitnessAppHomeScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

// import 'package:best_flutter_ui_templates/fitnessApp/models/tabIconData.dart';
// import 'package:best_flutter_ui_templates/fitnessApp/traning/trainingScreen.dart';
// import 'package:flutter/material.dart';
// import 'bottomNavigationView/bottomBarView.dart';
// import 'fintnessAppTheme.dart';
// import 'myDiary/myDiaryScreen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
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

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
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
                animationController.reverse().then((data) {
                  if (!mounted) return;
                  setState(() {
                    tabBody =
                        ShopPage(animationController: animationController);
                  });
                });
                break;
              case 2:
                animationController.reverse().then((data) {
                  if (!mounted) return;
                  setState(() {
                    tabBody =
                        CartPage(animationController: animationController);
                  });
                });
                break;
              case 3:
                animationController.reverse().then((data) {
                  if (!mounted) return;
                  setState(() {
                    tabBody =
                        ProfilePage(animationController: animationController);
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

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
