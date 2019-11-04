import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/pages/holder.dart';
import 'package:litpic/services/auth.dart';
import 'package:litpic/services/db.dart';
import 'package:litpic/services/fcm_notification.dart';
import 'package:litpic/services/modal.dart';
import 'package:litpic/services/package_device_info.dart';
import 'package:litpic/services/validater.dart';

final GetIt getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  getIt.registerSingleton<Auth>(AuthImplementation(), signalsReady: true);
  getIt.registerSingleton<DB>(DBImplementation(), signalsReady: true);
  getIt.registerSingleton<FCMNotification>(FCMNotificationImplementation(),
      signalsReady: true);

  getIt.registerSingleton<Modal>(ModalImplementation(), signalsReady: true);
  getIt.registerSingleton<PackageDeviceInfo>(PackageDeviceInfoImplementation(),
      signalsReady: true);
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
