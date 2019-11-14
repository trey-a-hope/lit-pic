import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/pay_flow_diagram.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/models/stripe/credit_card.dart';
import 'package:litpic/pages/shop/checkout_success.dart';
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
                                PayFlowDiagram(shippingComplete: true, paymentComplete: true, submitComplete: false),

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
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('Users')
                      .document(_currentUser.id)
                      .collection('Cart Items')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    //Reset total on every change.
                    items = 0;
                    if (!snapshot.hasData)
                      return Center(
                        child: Text('Loading...'),
                      );
                    else if (snapshot.hasData &&
                        snapshot.data.documents.isEmpty) {
                      items = 0;
                      Future.delayed(Duration.zero, () => setState(() {}));

                      return Center(
                        child: Text('Your shopping cart is empty.'),
                      );
                    } else {
                      return ListView(
                        shrinkWrap: true,
                        children:
                            snapshot.data.documents.map((DocumentSnapshot doc) {
                          CartItem cartItem = CartItem.fromDoc(doc: doc);

                          items += cartItem.quantity;
                          Future.delayed(Duration.zero, () => setState(() {}));

                          return _cartItem(
                            cartItem: cartItem,
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
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
                  onPressed: () async {
                    bool confirm = await getIt<ModalService>().showConfirmation(
                        context: context,
                        title: 'Submit Payment',
                        message:
                            '${getIt<FormatterService>().money(amount: orderTotal)} will be charged to your card.');
                    if (confirm) {
                      //CREATE/PAY ORDER
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutSuccessPage(),
                          ),
                        );
                    }
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
        ),
      ),
    );
  }

  Widget _cartItem({@required CartItem cartItem}) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Lithophane'),
          leading: Container(
            width: 100,
            height: 100,
            child: Image(
              image: CachedNetworkImageProvider(cartItem.imgUrl),
              fit: BoxFit.contain,
            ),
          ),
          subtitle: Text('${cartItem.quantity}'),
        ),
        Divider(),
      ],
    );
  }
}
