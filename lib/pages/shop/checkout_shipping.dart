import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/pages/profile/edit_address_page.dart';
import 'package:litpic/pages/shop/checkout_payment.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';

class CheckoutShippingPage extends StatefulWidget {
  @override
  State createState() => CheckoutShippingPageState();
}

class CheckoutShippingPageState extends State<CheckoutShippingPage> {
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
      _currentUser = await getIt<AuthService>().getCurrentUser();
      _currentUser.customer = await getIt<StripeCustomer>()
          .retrieve(customerID: _currentUser.customerID);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose Shipping',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _load();
            },
          )
        ],
      ),
      body: _isLoading
          ? Spinner()
          : Column(
              children: <Widget>[
                _currentUser.customer.address == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPaymentPage(),
                                ),
                              );
                            },
                            leading: Icon(Icons.location_city),
                            title: Text(_currentUser.customer.address.line1 +
                                ', ' +
                                _currentUser.customer.address.city +
                                ''),
                            subtitle: Text(_currentUser.customer.address.state +
                                ' ' +
                                _currentUser.customer.address.postalCode),
                            trailing: Icon(Icons.chevron_right),
                          ),
                        ),
                      ),
                _currentUser.customer.address == null
                    ? RaisedButton(
                        child: Text('Add Address'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAddressPage(),
                            ),
                          );
                        },
                      )
                    : RaisedButton(
                        child: Text('Update Address on File'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditAddressPage(),
                            ),
                          );
                        },
                      )
              ],
            ),
    );
  }
}
