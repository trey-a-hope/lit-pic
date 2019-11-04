import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/pages/authentication/login_page.dart';
import 'package:litpic/services/modal.dart';
import 'package:litpic/services/auth.dart';
import 'package:litpic/models/database/user.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({@required this.images});
  final List<File> images;
  @override
  State createState() => CheckoutPageState(images: images);
}

class CheckoutPageState extends State<CheckoutPage> {
  CheckoutPageState({@required this.images});
  final List<File> images;

  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    try {
      _currentUser = await getIt<Auth>().getCurrentUser();
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<Modal>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Spinner()
          : Center(
              child: Text('Images ${images.length}'),
            ),
    );
  }
}
