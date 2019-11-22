import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/models/stripe/sku.dart';
import 'package:litpic/pages/choose_shipping_page.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe/sku.dart';
import 'package:litpic/views/cart_item_view.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/title_view.dart';
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
  bool loadComplete = false;
  bool addAllListDataComplete = false;
  bool calculateTotalsComplete = false;

  bool fetchCartItemsComplete = false;
  List<CartItem> cartItems = List<CartItem>();
  int totalLithophanes = 0;
  final double shippingFee = 0.0;
  // Coupon _coupon;
  Sku _sku;

  double subTotal = 0.0;
  double stripeProcessingFee = 0.0;
  double monthlyDiscount;
  double total = 0.0;
  double totalWithCoupon = 0.0;

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
            showExtra: false,
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
        for (int i = 0; i < cartItems.length; i++) {
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
                  'Sub total',
                ),
                Text(getIt<FormatterService>().money(amount: subTotal),
                    style: TextStyle(fontWeight: FontWeight.bold))
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
                  'Shipping',
                ),
                Text(getIt<FormatterService>().money(amount: shippingFee),
                    style: TextStyle(fontWeight: FontWeight.bold))
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
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Processing fee'),
                    Text(
                      '2.9% + \$0.30 per transaction',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                Text(
                    '+${getIt<FormatterService>().money(amount: stripeProcessingFee)}',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
        listViews.add(Divider());

        TextStyle orderTotalStyle = TextStyle(
            fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20);
        listViews.add(
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Order Total',
                  style: orderTotalStyle,
                ),
                Text(
                  getIt<FormatterService>().money(amount: total),
                  style: orderTotalStyle,
                )
              ],
            ),
          ),
        );

        listViews.add(Divider());

        listViews.add(
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: RoundButtonView(
              text: 'PROCEED TO CHECKOUT',
              buttonColor: Colors.amber,
              onPressed: () {
                prefs.setDouble('subTotal', subTotal);
                prefs.setDouble('stripeProcessingFee', stripeProcessingFee);
                prefs.setDouble('shippingFee', shippingFee);
                prefs.setDouble('total', total);
                prefs.setInt('totalLithophanes', totalLithophanes);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ChooseShippingPage();
                  }),
                );
              },
              textColor: Colors.white,
              animation: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              ),
              animationController: widget.animationController,
            ),
          ),
        );
      }
    }
  }

  double getSubTotal() {
    return totalLithophanes * _sku.price;
  }

  double getStripeProcessingFee() {
    double subTotal = getSubTotal();
    return (subTotal * 0.029) + 0.3;
  }

  double getTotal() {
    double subTotal = getSubTotal();
    double stripeProcessingFee = getStripeProcessingFee();
    return subTotal + stripeProcessingFee;
  }

  Future<void> fetchCartItems() async {
    if (!fetchCartItemsComplete) {
      /*
        Mark flag to prevent from multiple calls to this function.
        setState((){}) called due to scaffold bar animation.
      */
      fetchCartItemsComplete = true;

      //Clear list to prevent for duplicates later.
      cartItems.clear();

      //Restart total lithophanes count.
      totalLithophanes = 0;

      //Fetch cart item documents.
      List<DocumentSnapshot> docs = (await Firestore.instance
              .collection('Users')
              .document(_currentUser.id)
              .collection('Cart Items')
              .getDocuments())
          .documents;

      //Add cart items to list.
      for (int i = 0; i < docs.length; i++) {
        cartItems.add(
          CartItem.fromDoc(doc: docs[i]),
        );

        //Calculate total number of lithophanes for this order.
        totalLithophanes += cartItems[i].quantity;
      }
    }
  }

  calculateTotals() {
    if (!calculateTotalsComplete) {
      calculateTotalsComplete = true;
      subTotal = getSubTotal();
      stripeProcessingFee = getStripeProcessingFee();
      // monthlyDiscount = getMonthlyDiscount();
      total = getTotal();
      // totalWithCoupon = getTotalWithCoupon();
    }
  }

  Future<void> load() async {
    if (!loadComplete) {
      loadComplete = true;
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
  }

  // Future<void> fetchMonthlyCoupon() async {
  //   final String couponID = await getIt<DBService>().retrieveCouponID();
  //   _coupon = await getIt<StripeCoupon>().retrieve(couponID: couponID);
  //   return;
  // }

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
    // futures.add(fetchMonthlyCoupon());
    futures.add(fetchLithophaneSku());

    return FutureBuilder(
      future: Future.wait(futures),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Spinner();
        } else {
          calculateTotals();
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
                                : IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                        listViews.clear();
                                      });

                                      //Re add views with new data.
                                      loadComplete = false;
                                      await load();

                                      //Re add views with new data.
                                      addAllListDataComplete = false;
                                      addAllListData();

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                    icon: Icon(Icons.refresh),
                                  )
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
      fetchCartItemsComplete = false;
      await fetchCartItems();

      //Rerun total calculations.
      calculateTotalsComplete = false;
      calculateTotals();

      //Re add views with new data.
      addAllListDataComplete = false;
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

    //Refresh cart data.
    fetchCartItemsComplete = false;
    await fetchCartItems();

    //Rerun total calculations.
    calculateTotalsComplete = false;
    calculateTotals();

    //Re add views with new data.
    addAllListDataComplete = false;
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

    //Refresh cart data.
    fetchCartItemsComplete = false;
    await fetchCartItems();

    //Rerun total calculations.
    calculateTotalsComplete = false;
    calculateTotals();

    //Re add views with new data.
    addAllListDataComplete = false;
    addAllListData();

    //
    setState(() {
      _isLoading = false;
    });
  }
}

//Future.delayed(Duration.zero, () => setState(() {}));
