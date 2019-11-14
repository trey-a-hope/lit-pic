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

class CheckoutPaymentPage extends StatefulWidget {
  @override
  State createState() => CheckoutPaymentPageState();
}

class CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
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
          'Choose Payment',
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
          : _currentUser.customer.card == null
              ? RaisedButton(
                  child: Text('Add Card'),
                  onPressed: () {},
                )
              : Column(
                  children: <Widget>[
                                    PayFlowDiagram(shippingComplete: true, paymentComplete: false, submitComplete: false),

                    _buildCreditCard(creditCard: _currentUser.customer.card),
                    RaisedButton(
                      child: Text('Update Default Card'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedCardsPage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
    );
  }

  _buildCreditCard({@required CreditCard creditCard}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 3,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutFinalPage(),
              ),
            );
          },
          leading: Icon(Icons.credit_card,
              color: _currentUser.customer.defaultSource == creditCard.id
                  ? Colors.green
                  : Colors.black),
          title:
              Text('${creditCard.brand} / ****-****-****-${creditCard.last4}'),
          subtitle: Text('Expires ' +
              months[creditCard.expMonth] +
              ' ' +
              '${creditCard.expYear}'),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
