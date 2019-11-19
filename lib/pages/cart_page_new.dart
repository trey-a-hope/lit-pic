import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/cart_item_view.dart';
import 'package:litpic/common/good_button.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/models/stripe/coupon.dart';
import 'package:litpic/models/stripe/sku.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe/coupon.dart';
import 'package:litpic/services/stripe/sku.dart';
import 'package:litpic/titleView.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  final AnimationController animationController;

  const CartPage({Key key, this.animationController}) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final GetIt getIt = GetIt.I;
  final Color iconColor = Colors.amber[700];
  User _currentUser;
  SharedPreferences prefs;
  bool addAllListDataComplete = false;
  List<CartItem> cartItems = List<CartItem>();
  int items = 0;
  // double price = 15.00;
  Coupon _coupon;
  Sku _sku;

  bool _isLoading = false;

  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );
    // addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() async {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;

      var count = 1;

      // listViews.clear();

      if (cartItems.isEmpty) {
        listViews.add(
          TitleView(
            titleTxt: 'Your cart is empty boss.',
            subTxt: 'Shop',
            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 0, 1.0,
                    curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        );
      } else {
        items = 0;
        for (int i = 0; i < cartItems.length; i++) {
          items += cartItems[i].quantity;
          listViews.add(
            Padding(
              padding: EdgeInsets.all(10),
              child: CartItemView(
                price: _sku.price,
                delete: () {
                  listViews.clear();
                  _deleteCartItem(cartItem: cartItems[i]);
                },
                cartItem: cartItems[i],
                animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / count) * 0, 1.0,
                        curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
                increment: () {
                  listViews.clear();
                  _incrementQuantity(cartItem: cartItems[i]);
                },
                decrement: () {
                  listViews.clear();
                  _decrementQuantity(cartItem: cartItems[i]);
                },
              ),
            ),
          );
        }
        listViews.add(Divider());

        listViews.add(
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Shipping',
                ),
                Text(
                  'Free',
                )
              ],
            ),
          ),
        );

        listViews.add(
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                ),
                Text(
                  getTotal(),
                )
              ],
            ),
          ),
        );

        listViews.add(
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total w/ Coupon',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
                Text(
                  getCouponTotal() + ' ( ${_coupon.percentOff} % Off )',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                )
              ],
            ),
          ),
        );

        listViews.add(Divider());

        listViews.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: GoodButton(
              text: 'PROCEED TO CHECKOUT',
              buttonColor: Colors.amber,
              onPressed: () {
                getIt<ModalService>().showAlert(
                    context: context,
                    title: 'Proceed To Checkout',
                    message: 'ToDo');
              },
              textColor: Colors.white,
            ),
          ),
        );
      }
    }
  }

  String getTotal() {
    double total = 0;
    total = items * _sku.price;
    prefs.setDouble('itemsTotal', total);

    return getIt<FormatterService>().money(amount: total);
  }

  String getCouponTotal() {
    double total = 0;
    total = items * _sku.price;
    total *= (1 - (_coupon.percentOff / 100));
    // prefs.setDouble('itemsTotal', total);

    return getIt<FormatterService>().money(amount: total);
  }

  Future<void> fetchCartItems() async {
    cartItems.clear();
    List<DocumentSnapshot> docs = (await Firestore.instance
            .collection('Users')
            .document(_currentUser.id)
            .collection('Cart Items')
            .getDocuments())
        .documents;
    for (int i = 0; i < docs.length; i++) {
      cartItems.add(
        CartItem.fromDoc(doc: docs[i]),
      );
    }
  }

  Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    try {
      _currentUser = await getIt<AuthService>().getCurrentUser();
      await fetchCartItems();
      return;
    } catch (e) {
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
      return;
    }
  }

  Future<void> fetchMonthlyCoupon() async {
    final String couponID = await getIt<DBService>().retrieveCouponID();
    _coupon = await getIt<StripeCoupon>().retrieve(couponID: couponID);
    return;
  }

  Future<void> fetchLithophaneSku() async {
    final String skuID = await getIt<DBService>().retrieveSkuID();
    _sku = await getIt<StripeSku>().retrieve(skuID: skuID);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LitPicTheme.background,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          )),
    );
  }

  Widget getMainListViewUI() {
    List<Future> futures = List<Future>();
    futures.add(load());
    futures.add(fetchMonthlyCoupon());
    futures.add(fetchLithophaneSku());

    return FutureBuilder(
      future: Future.wait(futures),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Spinner();
        } else {
          addAllListData();
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
    // return StreamBuilder<QuerySnapshot>(
    //   stream: Firestore.instance
    //       .collection('Users')
    //       .document('NnWUARGr7dK9Zx6jxrgH')
    //       .collection('Cart Items')
    //       .snapshots(),
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     //Reset total on every change.
    //     if (!snapshot.hasData)
    //       return Spinner();
    //     else if (snapshot.hasData && snapshot.data.documents.isEmpty) {
    //       Future.delayed(Duration.zero, () => setState(() {}));

    //       return Center(
    //         child: Text('Your shopping cart is empty.'),
    //       );
    //     } else {
    //       widget.animationController.forward();

    //       return ListView(
    //         // controller: scrollController,
    //         shrinkWrap: true,
    //         padding: EdgeInsets.only(
    //           top: AppBar().preferredSize.height +
    //               MediaQuery.of(context).padding.top +
    //               24,
    //           bottom: 62 + MediaQuery.of(context).padding.bottom,
    //         ),
    //         children: snapshot.data.documents.map((DocumentSnapshot doc) {
    //           CartItem cartItem = CartItem.fromDoc(doc: doc);

    //           Future.delayed(Duration.zero, () => setState(() {}));

    //           return Padding(
    //             padding: EdgeInsets.all(10),
    //             child: CartItemView(
    //               delete: () {
    //                 // _deleteCartItem(cartItem: cartItems[i]);
    //               },
    //               cartItem: cartItem,
    //               animation: Tween(begin: 0.0, end: 1.0).animate(
    //                   CurvedAnimation(
    //                       parent: widget.animationController,
    //                       curve: Interval((1 / 1) * 0, 1.0,
    //                           curve: Curves.fastOutSlowIn))),
    //               animationController: widget.animationController,
    //               increment: () {
    //                 // _incrementQuantity(cartItem: cartItems[i]);
    //               },
    //               decrement: () {
    //                 // _decrementQuantity(cartItem: cartItems[i]);
    //               },
    //             ),
    //           );
    //         }).toList(),
    //       );
    //     }
    //   },
    // );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: LitPicTheme.white.withOpacity(topBarOpacity),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color:
                              LitPicTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Shopping Cart",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: LitPicTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: LitPicTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            _isLoading
                                ? CircularProgressIndicator(
                                    // backgroundColor: Colors.black,
                                    strokeWidth: 3.0,
                                  )
                                : SizedBox.shrink()
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_left,
                            //         color: LitPicTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     left: 8,
                            //     right: 8,
                            //   ),
                            //   child: Row(
                            //     children: <Widget>[
                            //       Padding(
                            //         padding: const EdgeInsets.only(right: 8),
                            //         child: Icon(
                            //           Icons.calendar_today,
                            //           color: LitPicTheme.grey,
                            //           size: 18,
                            //         ),
                            //       ),
                            //       Text(
                            //         "15 May",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontFamily: LitPicTheme.fontName,
                            //           fontWeight: FontWeight.normal,
                            //           fontSize: 18,
                            //           letterSpacing: -0.2,
                            //           color: LitPicTheme.darkerText,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.keyboard_arrow_right,
                            //         color: LitPicTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  _deleteCartItem({@required CartItem cartItem}) async {
    bool confirm = await getIt<ModalService>().showConfirmation(
        context: context,
        title: 'Remove Item From Cart',
        message: 'Are you sure.');
    if (confirm) {
      setState(() {
        _isLoading = true;
      });

      //Remove cart item from database.
      await getIt<DBService>()
          .deleteCartItem(userID: _currentUser.id, cartItemID: cartItem.id);

      //Remove image of cart item from storage.
      await getIt<StorageService>().deleteImage(imgPath: cartItem.imgPath);

      //Refresh cart data.
      await load();

      //
      addAllListDataComplete = false;

      //
      addAllListData();

      //
      setState(() {
        _isLoading = false;
      });
    }
  }

  _incrementQuantity({@required CartItem cartItem}) async {
    setState(() {
      _isLoading = true;
    });

    await getIt<DBService>().updateCartItem(
        userID: _currentUser.id,
        cartItemID: cartItem.id,
        data: {'quantity': cartItem.quantity + 1});

    //
    addAllListDataComplete = false;

    //
    addAllListData();

    //
    setState(() {
      _isLoading = false;
    });
  }

  _decrementQuantity({@required CartItem cartItem}) async {
    if (cartItem.quantity == 1) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await getIt<DBService>().updateCartItem(
        userID: _currentUser.id,
        cartItemID: cartItem.id,
        data: {'quantity': cartItem.quantity - 1});

    //
    addAllListDataComplete = false;

    //
    addAllListData();

    //
    setState(() {
      _isLoading = false;
    });
  }
}
