import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/modal_service.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final GetIt getIt = GetIt.I;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  User _currentUser;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    getIt<AuthService>().onAuthStateChanged().listen(
      (firebaseUser) {
        setState(
          () {
            _isLoggedIn = firebaseUser != null;
            if (_isLoggedIn) {
              _load();
            } else {
              _isLoading = false;
            }
          },
        );
      },
    );
  }

  _load() async {
    try {
      _currentUser = await getIt<AuthService>().getCurrentUser();
      _setUpFirebaseMessaging();

      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  void _setUpFirebaseMessaging() async {
    if (Platform.isIOS) {
      //Request permission on iOS device.
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    }

    //Update user's fcm token.
    final String fcmToken = await _fcm.getToken();
    if (fcmToken != null) {
      print(fcmToken);
      getIt<DBService>()
          .updateUser(userID: _currentUser.id, data: {'fcmToken': fcmToken});
    }

    //Configure notifications for several action types.
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        getIt<ModalService>().showAlert(
            context: context,
            title: message['notification']['title'],
            message: '');
      },
      onLaunch: (Map<String, dynamic> message) async {
        getIt<ModalService>().showAlert(
            context: context,
            title: message['notification']['title'],
            message: '');
      },
      onResume: (Map<String, dynamic> message) async {
        getIt<ModalService>().showAlert(
            context: context,
            title: message['notification']['title'],
            message: '');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[],
    );
  }
}
