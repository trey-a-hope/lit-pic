import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class IModalService {
  // void showInSnackBar(
  //     {@required GlobalKey<ScaffoldState> scaffoldKey,
  //     @required String message});
  void showAlert(
      {@required BuildContext context,
      @required String title,
      @required String message});
  // Future<String> showPasswordResetEmail({@required BuildContext context});
  // Future<String> showChangeEmail({@required BuildContext context});
  Future<bool> showConfirmation(
      {@required BuildContext context,
      @required String title,
      @required String message});
}

class ModalService extends IModalService {
  final GetIt getIt = GetIt.I;

  // @override
  // void showInSnackBar(
  //     {@required GlobalKey<ScaffoldState> scaffoldKey,
  //     @required String message}) {
  //   scaffoldKey.currentState.showSnackBar(SnackBar(
  //     content: Text(message),
  //   ));
  // }

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

  // @override
  // Future<String> showPasswordResetEmail({@required BuildContext context}) {
  //   final TextEditingController emailController = TextEditingController();
  //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //   bool _autovalidate = false;

  //   return showDialog<String>(
  //     barrierDismissible: false,
  //     context: context,
  //     child: AlertDialog(
  //       title: Text('Reset Password'),
  //       content: Form(
  //         key: _formKey,
  //         autovalidate: _autovalidate,
  //         child: TextFormField(
  //           controller: emailController,
  //           keyboardType: TextInputType.emailAddress,
  //           textInputAction: TextInputAction.next,
  //           maxLengthEnforced: true,
  //           // maxLength: MyFormData.nameCharLimit,
  //           onFieldSubmitted: (term) {},
  //           validator: getIt<Validator>().email,
  //           onSaved: (value) {},
  //           decoration: InputDecoration(
  //             hintText: 'Email',
  //             icon: Icon(Icons.email),
  //             fillColor: Colors.white,
  //           ),
  //         ),
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: const Text('CANCEL'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         FlatButton(
  //           child: const Text('SUBMIT'),
  //           onPressed: () {
  //             final FormState form = _formKey.currentState;
  //             if (!form.validate()) {
  //               _autovalidate = true;
  //             } else {
  //               Navigator.of(context).pop(emailController.text);
  //             }
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  // @override
  // Future<String> showChangeEmail({@required BuildContext context}) {
  //   final TextEditingController emailController = TextEditingController();
  //   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //   bool _autovalidate = false;

  //   return showDialog<String>(
  //     barrierDismissible: false,
  //     context: context,
  //     child: AlertDialog(
  //       title: Text('Change Email'),
  //       content: Form(
  //         key: _formKey,
  //         autovalidate: _autovalidate,
  //         child: TextFormField(
  //           controller: emailController,
  //           keyboardType: TextInputType.emailAddress,
  //           textInputAction: TextInputAction.next,
  //           maxLengthEnforced: true,
  //           // maxLength: MyFormData.nameCharLimit,
  //           onFieldSubmitted: (term) {},
  //           validator: getIt<Validator>().email,
  //           onSaved: (value) {},
  //           decoration: InputDecoration(
  //             hintText: 'New Email',
  //             icon: Icon(Icons.email),
  //             fillColor: Colors.white,
  //           ),
  //         ),
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: const Text('CANCEL'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         FlatButton(
  //           child: const Text('SUBMIT'),
  //           onPressed: () {
  //             final FormState form = _formKey.currentState;
  //             if (!form.validate()) {
  //               _autovalidate = true;
  //             } else {
  //               Navigator.of(context).pop(emailController.text);
  //             }
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

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
