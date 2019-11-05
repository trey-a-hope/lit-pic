import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/pages/authentication/login_page.dart';
import 'package:litpic/services/db.dart';
import 'package:litpic/services/formatter.dart';
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
  double total = 0;

  List<CartItem> _cartItems = List<CartItem>();

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
    return ListView(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Users')
              .document(_currentUser.id)
              .collection('Cart Items')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Text('Loading...'),
              );
            else if (snapshot.hasData && snapshot.data.documents.isEmpty) {
              return Center(
                child: Text('Your shopping cart is empty.'),
              );
            } 
            else {
              return ListView(
                shrinkWrap: true,
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  CartItem cartItem = CartItem.fromDoc(doc: document);
                  return _cartItem(
                    cartItem: cartItem,
                  );
                }).toList(),
              );
            }
          },
        ),
        Container(
          color: Colors.black,
          height: 60,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total : ' + _total(),
                    style: TextStyle(color: Colors.white),
                  ),
                  RaisedButton(
                    child: Text('Checkout'),
                    onPressed: () {},
                  )
                ],
              )),
        )
      ],
    );
  }

  String _total() {
    double total = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      total += _cartItems[i].quantity * 15.00;
    }
    return getIt<Formatter>().money(amount: total);
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
          subtitle: Row(
            children: <Widget>[
              cartItem.quantity == 1
                  ? Container()
                  : FlatButton(
                      child: Icon(Icons.chevron_left),
                      onPressed: () {
                        getIt<DB>().updateCartItem(
                            userID: _currentUser.id,
                            cartItemID: cartItem.id,
                            data: {'quantity': cartItem.quantity - 1});
                      },
                    ),
              Text('${cartItem.quantity}'),
              FlatButton(
                child: Icon(Icons.chevron_right),
                onPressed: () {
                  getIt<DB>().updateCartItem(
                      userID: _currentUser.id,
                      cartItemID: cartItem.id,
                      data: {'quantity': cartItem.quantity + 1});
                },
              )
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteCartItem(cartItem: cartItem),
          ),
        ),
        Divider(),
      ],
    );
  }

  _deleteCartItem({@required CartItem cartItem}) async {
    bool confirm = await getIt<Modal>().showConfirmation(
        context: context,
        title: 'Remove Item From Cart',
        message: 'Are you sure.');
    if (confirm) {
      print('delete this item');
    }
  }
}
