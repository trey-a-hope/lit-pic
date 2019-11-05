import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/pages/holder.dart';
import 'package:litpic/services/auth.dart';
import 'package:litpic/services/db.dart';
import 'package:litpic/services/fcm_notification.dart';
import 'package:litpic/services/formatter.dart';
import 'package:litpic/services/modal.dart';
import 'package:litpic/services/package_device_info.dart';
import 'package:litpic/services/storage.dart';
import 'package:litpic/services/stripe/card.dart';
import 'package:litpic/services/stripe/charge.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/stripe/token.dart';
import 'package:litpic/services/validater.dart';

final GetIt getIt = GetIt.instance;

final String _testSecretKey = 'sk_test_6s03VnuOvJtDW7a6ygpFdDdM00Jxr17MUX';
final String _testPublishableKey = 'pk_test_E2jn7tAPmhIlGYM2rg1hzQWc00DAPdLu9K';
final String _liveSecretKey = '?';
final String _livePublishableKey = '?';
final String _endpoint =
    'https://us-central1-hidden-gems-e481d.cloudfunctions.net/';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Authentication
  getIt.registerSingleton<Auth>(AuthImplementation(), signalsReady: true);
  //Database
  getIt.registerSingleton<DB>(DBImplementation(), signalsReady: true);
  //Firebase Cloud Messaging
  getIt.registerSingleton<FCMNotification>(FCMNotificationImplementation(),
      signalsReady: true);
  //Formatter
  getIt.registerSingleton<Formatter>(FormatterImplementation(),
      signalsReady: true);
  //Modal
  getIt.registerSingleton<Modal>(ModalImplementation(), signalsReady: true);
  //Package Device Info
  getIt.registerSingleton<PackageDeviceInfo>(PackageDeviceInfoImplementation(),
      signalsReady: true);
  //Storage
  getIt.registerSingleton<Storage>(StorageImplementation(), signalsReady: true);
  //Stripe Card
  getIt.registerSingleton<StripeCard>(
      StripeCardImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Stripe Charge
  getIt.registerSingleton<StripeCharge>(
      StripeChargeImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Stripe Customer
  getIt.registerSingleton<StripeCustomer>(
      StripeCustomerImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Stripe Token
  getIt.registerSingleton<StripeToken>(
      StripeTokenImplementation(apiKey: _testSecretKey, endpoint: _endpoint),
      signalsReady: true);
  //Validator
  getIt.registerSingleton<Validator>(ValidatorImplementation(),
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
      home: Holder(),
    );
  }
}
