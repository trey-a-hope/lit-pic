import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class IModalService {
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message});
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message});
}

class ModalService extends IModalService {
  @override
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          )
        : showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
  }

  @override
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message}) {
    return Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  )
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );
  }
}
