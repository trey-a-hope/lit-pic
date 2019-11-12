import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/models/stripe/credit_card.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutFinalPage extends StatefulWidget {
  @override
  State createState() => CheckoutFinalPageState();
}

class CheckoutFinalPageState extends State<CheckoutFinalPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  double orderTotal;
  double itemsTotal;
  double discountTotal;
  int items;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    _load();
  }

  _load() async {
    prefs = await SharedPreferences.getInstance();

    orderTotal = prefs.getDouble('orderTotal');
    items = prefs.getInt('items');
    itemsTotal = prefs.getDouble('itemsTotal');
    discountTotal = prefs.getDouble('discountTotal');
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
          'Place Order',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Spinner()
          : ListView(
              children: <Widget>[
                Text(
                  'Double check your order details.',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Shipping Address',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_currentUser.customer.address.line1 +
                    ' ' +
                    _currentUser.customer.address.city +
                    ' ' +
                    _currentUser.customer.address.state +
                    ' ' +
                    _currentUser.customer.address.postalCode),
                Text(
                  'Payment Method',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildCreditCard(creditCard: _currentUser.customer.card),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('${items == 1 ? 'Item' : 'Items'} total'),
                    Text(getIt<FormatterService>().money(amount: itemsTotal))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Discount (Buy 2, Get 1 Free)'),
                    Text(getIt<FormatterService>().money(amount: discountTotal))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Text('Shipping'), Text('Free')],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Order total ($items ${items == 1 ? 'item' : 'items'})',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getIt<FormatterService>().money(amount: orderTotal),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                RaisedButton(
                  child: Text('Submit Order'),
                  onPressed: () {
                    getIt<ModalService>().showAlert(
                        context: context,
                        title: 'Submit Payment',
                        message: 'TODO');
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
