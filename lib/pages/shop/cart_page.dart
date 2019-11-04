import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/pages/authentication/login_page.dart';
import 'package:litpic/services/modal.dart';
import 'package:litpic/services/auth.dart';
import 'package:litpic/models/database/user.dart';

class CartPage extends StatefulWidget {
  @override
  State createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  List<CartItem> items = List<CartItem>();

  @override
  void initState() {
    super.initState();

    super.initState();
    getIt<Auth>().onAuthStateChanged().listen(
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
    return _isLoading
        ? Spinner()
        : _isLoggedIn ? isLoggedInView() : LoggedOutView();
  }

  Widget isLoggedInView() {
    return items.isEmpty
        ? Center(
            child: Text('Your shopping cart is empty.'),
          )
        : ListView(children: <Widget>[]);
  }
}
