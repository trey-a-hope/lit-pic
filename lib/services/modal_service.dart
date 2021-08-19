import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class IModalService {
  void showAlert(
      {required BuildContext context,
      required String title,
      required String message});
  Future<dynamic> showConfirmation(
      {required BuildContext context,
      required String title,
      required String message});

  Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    required String hintText,
  });
}

class ModalService extends IModalService {
  @override
  void showAlert(
      {required BuildContext context,
      required String title,
      required String message}) {
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
                  TextButton(
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
  Future<dynamic> showConfirmation(
      {required BuildContext context,
      required String title,
      required String message}) async {
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
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
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

  Future<String?> showInputDialog({
    required BuildContext context,
    required String title,
    required String hintText,
  }) async {
    TextEditingController controller = TextEditingController();
    return Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: Material(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: hintText),
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Submit'),
                    onPressed: () {
                      if (controller.text.isNotEmpty)
                        Navigator.of(context).pop(controller.text);
                    },
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  )
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(title),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: hintText),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (controller.text.isNotEmpty)
                        Navigator.of(context).pop(controller.text);
                    },
                  ),
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                ],
              );
            });
  }
}
