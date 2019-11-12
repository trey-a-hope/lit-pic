import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/pages/shop/checkout_shipping.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  State createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;
  int items = 0;
  int freeLithophanes = 0;
  double price = 15.00;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    prefs = await SharedPreferences.getInstance();
    try {
      _currentUser = await getIt<AuthService>().getCurrentUser();
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
    return _isLoading
        ? Spinner()
        : ListView(
            children: <Widget>[
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
                  Text(getItemsTotal())
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Discount (Buy 2, Get 1 Free)'),
                  Text(getDiscountTotal())
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
                    getOrderTotal(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Container(
                color: Colors.black,
                height: 60,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    child: Text('Proceed To Checkout'),
                    onPressed: () {

                      prefs.setInt('items', items);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutShippingPage(),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
  }

  //Buy two, get one free.
  String getOrderTotal() {
    double total = 0;
    freeLithophanes = (items / 3).floor();
    double discount = freeLithophanes * price;
    total = items * price;
    total -= discount;
    prefs.setDouble('orderTotal', total);
    return getIt<FormatterService>().money(amount: total);
  }

  String getItemsTotal() {
    double total = 0;
    total = items * price;
        prefs.setDouble('itemsTotal', total);

    return getIt<FormatterService>().money(amount: total);
  }

  String getDiscountTotal() {
    double discount = freeLithophanes * price;
            prefs.setDouble('discountTotal', discount);

    return getIt<FormatterService>().money(amount: discount);
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
                  ? SizedBox.shrink()
                  : FlatButton(
                      child: Icon(Icons.chevron_left),
                      onPressed: () {
                        getIt<DBService>().updateCartItem(
                            userID: _currentUser.id,
                            cartItemID: cartItem.id,
                            data: {'quantity': cartItem.quantity - 1});
                      },
                    ),
              Text('${cartItem.quantity}'),
              FlatButton(
                child: Icon(Icons.chevron_right),
                onPressed: () {
                  getIt<DBService>().updateCartItem(
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
    bool confirm = await getIt<ModalService>().showConfirmation(
        context: context,
        title: 'Remove Item From Cart',
        message: 'Are you sure.');
    if (confirm) {
      //Remove cart item from database.
      getIt<DBService>()
          .deleteCartItem(userID: _currentUser.id, cartItemID: cartItem.id);

      //Remove image of cart item from storage.
      getIt<StorageService>().deleteImage(imgPath: cartItem.imgPath);
    }
  }
}
