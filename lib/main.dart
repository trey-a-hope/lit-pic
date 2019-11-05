import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/pages/holder.dart';
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
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/stripe/token.dart';
import 'package:litpic/services/validater_service.dart';

final GetIt getIt = GetIt.instance;


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //Authentication
  getIt.registerSingleton<AuthService>(AuthServiceImplementation(), signalsReady: true);
  //Database
  getIt.registerSingleton<DBService>(DBServiceImplementation(), signalsReady: true);
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
  getIt.registerSingleton<ModalService>(ModalServiceImplementation(), signalsReady: true);
  //Package Device Info
  getIt.registerSingleton<DeviceService>(DeviceServiceImplementation(),
      signalsReady: true);
  //Storage
  getIt.registerSingleton<StorageService>(StorageServiceImplementation(), signalsReady: true);
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
      home: Holder(),
    );
  }
}
