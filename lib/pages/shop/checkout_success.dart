import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/pay_flow_diagram.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/models/stripe/credit_card.dart';
import 'package:litpic/pages/payments/add_credit_card_page.dart';
import 'package:litpic/pages/payments/saved_cards_page.dart';
import 'package:litpic/pages/shop/checkout_final.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/card.dart';
import 'package:litpic/services/stripe/customer.dart';

class CheckoutSuccessPage extends StatefulWidget {
  @override
  State createState() => CheckoutSuccessPageState();
}

class CheckoutSuccessPageState extends State<CheckoutSuccessPage> {
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
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text(
        //     'Payment Received',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(Icons.refresh),
        //       onPressed: () {
        //         setState(() {
        //           _isLoading = true;
        //         });
        //         _load();
        //       },
        //     )
        //   ],
        // ),
        body: Center(
      child: Container(
        height: 150,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: <Widget>[
            PayFlowDiagram(
              shippingComplete: true,
              paymentComplete: true,
              submitComplete: true,
            ),
            Text('Success'),
            Text('Thank you for shopping with us.'),
            Text('Your order is on the way.'),
            RaisedButton(
              child: Text('Return Home'),
              onPressed: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName(Navigator.defaultRouteName),
                );
              },
            )
          ],
        ),
      ),
    ));
  }
}
