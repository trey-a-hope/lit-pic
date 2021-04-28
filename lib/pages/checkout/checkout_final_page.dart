import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/models/stripe/sku.dart';
import 'package:litpic/pages/checkout/checkout_success_page.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/fcm_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/stripe/order.dart';
import 'package:litpic/services/stripe/sku.dart';
import 'package:litpic/views/cart_item_bought_view.dart';
import 'package:litpic/views/pay_flow_diagram_view.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutFinalPage extends StatefulWidget {
  const CheckoutFinalPage({Key key}) : super(key: key);
  @override
  _CheckoutFinalPageState createState() => _CheckoutFinalPageState();
}

class _CheckoutFinalPageState extends State<CheckoutFinalPage>
    with TickerProviderStateMixin {
  AnimationController animationController;

  Animation<double> topBarAnimation;

  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final GetIt getIt = GetIt.I;
  List<CartItem> cartItems = List<CartItem>();

  User _currentUser;

  bool fetchCartItemsComplete = false;
  bool loadCustomerInfoComplete = false;
  bool addAllListDataComplete = false;

  bool _isLoading = false;
  Sku _sku;
  SharedPreferences prefs;

  double subTotal;
  double shippingFee;
  double total;
  int totalLithophanes;

  String adminDocID;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

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

  void addAllListData() {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;
      var count = 5;

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
          child: PayFlowDiagramView(
            paymentComplete: true,
            shippingComplete: true,
            submitComplete: false,
            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 0, 1.0,
                    curve: Curves.fastOutSlowIn))),
            animationController: animationController,
          ),
        ),
      );

      listViews.add(Divider());

      for (int i = 0; i < cartItems.length; i++) {
        listViews.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: CartItemBoughtView(
              price: _sku.price,
              cartItem: cartItems[i],
              animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn))),
              animationController: animationController,
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
                'Shipping To',
              ),
              Text(
                '${_currentUser.customer.shipping.address.line1}\n${_currentUser.customer.shipping.address.city}, ${_currentUser.customer.shipping.address.state} ${_currentUser.customer.shipping.address.postalCode}',
                textAlign: TextAlign.end,
                style: TextStyle(fontWeight: FontWeight.bold),
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
                'Paying w/ Card',
              ),
              Text(
                '${_currentUser.customer.card.brand} - ${_currentUser.customer.card.last4}',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      );
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

      // listViews.add(
      //   Padding(
      //     padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Column(
      //           // mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             Text('Processing fee'),
      //             Text(
      //               '2.9% + \$0.30 per transaction',
      //               style: TextStyle(color: Colors.grey),
      //             )
      //           ],
      //         ),
      //         Text(
      //             '+${getIt<FormatterService>().money(amount: stripeProcessingFee)}',
      //             style: TextStyle(fontWeight: FontWeight.bold))
      //       ],
      //     ),
      //   ),
      // );

      listViews.add(
        Divider(),
      );

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
          padding: EdgeInsets.all(20),
          child: RoundButtonView(
            buttonColor: Colors.amber,
            text: 'SUBMIT PAYMENT',
            textColor: Colors.white,
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
            onPressed: _submit,
          ),
        ),
      );
    }
  }

  Future<void> loadCustomerInfo() async {
    if (!loadCustomerInfoComplete) {
      loadCustomerInfoComplete = true;
      prefs = await SharedPreferences.getInstance();

      try {
        //Load user and orders.
        _currentUser = await getIt<AuthService>().getCurrentUser();
        _currentUser.customer = await getIt<StripeCustomerService>()
            .retrieve(customerID: _currentUser.customerID);
        await fetchCartItems();

        subTotal = prefs.getDouble('subTotal');
        shippingFee = prefs.getDouble('shippingFee');
        total = prefs.getDouble('total');

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

  Future<void> fetchCartItems() async {
    if (!fetchCartItemsComplete) {
      /*
        Mark flag to prevent from multiple calls to this function.
        setState((){}) called due to scaffold bar animation.
      */
      fetchCartItemsComplete = true;

      //Clear list to prevent for duplicates later.
      cartItems.clear();

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
      }
    }
  }

  Future<void> fetchLithophaneSku() async {
    final String skuID = await getIt<DBService>().retrieveSkuID();
    _sku = await getIt<StripeSkuService>().retrieve(skuID: skuID);
    return;
  }

  Future<void> fetchAdminDocID() async {
    adminDocID = await getIt<DBService>().retrieveAdminDocID();
    return;
  }

  void _submit() async {
    bool confirm = await getIt<ModalService>().showConfirmation(
        context: context,
        title: 'Are you sure?',
        message:
            'Your default card will be charged ${getIt<FormatterService>().money(amount: total)}');
    if (confirm) {
      try {
        setState(() {
          _isLoading = true;
        });

        //Create order.
        final String orderID = await getIt<StripeOrderService>().create(
            line1: _currentUser.customer.shipping.address.line1,
            name: _currentUser.customer.shipping.name,
            email: _currentUser.customer.email,
            city: _currentUser.customer.shipping.address.city,
            state: _currentUser.customer.shipping.address.state,
            postalCode: _currentUser.customer.shipping.address.postalCode,
            country: _currentUser.customer.shipping.address.country,
            customerID: _currentUser.customerID,
            sku: _sku,
            cartItems: cartItems);

        //Pay order.
        await getIt<StripeOrderService>().pay(
            orderID: orderID,
            source: _currentUser.customer.defaultSource,
            customerID: _currentUser.customerID);

        //Create order document reference.
        DocumentReference ordersDocRef =
            await Firestore.instance.collection('Orders').add({
          'id': orderID,
          'name': _currentUser.customer.shipping.name,
          'email': _currentUser.customer.email
        });

        //Save cart items to database.
        for (int i = 0; i < cartItems.length; i++) {
          await ordersDocRef.collection('Cart Items').add(cartItems[i].toMap());
        }

        //Create user cart items reference.
        CollectionReference cartItemsColRef = Firestore.instance
            .collection('Users')
            .document(_currentUser.id)
            .collection('Cart Items');

        //Clear shopping cart.
        List<DocumentSnapshot> docs =
            (await cartItemsColRef.getDocuments()).documents;
        for (int i = 0; i < docs.length; i++) {
          await cartItemsColRef.document(docs[i].documentID).delete();
        }

        //Send notification to myself of new order created.
        User treyHope = await getIt<DBService>().retrieveUser(id: adminDocID);
        await getIt<FCMService>().sendNotificationToUser(
            fcmToken: treyHope.fcmToken,
            title: 'NEW ORDER',
            body: 'From ${_currentUser.customer.name}');

        //Navigate to success page.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutSuccessPage(),
          ),
        );
      } catch (e) {
        setState(
          () {
            _isLoading = false;
          },
        );
        getIt<ModalService>().showAlert(
          context: context,
          title: 'Error',
          message: e.toString(),
        );
      }
    }
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
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    List<Future> futures = List<Future>();
    futures.add(loadCustomerInfo());
    futures.add(fetchLithophaneSku());
    futures.add(fetchAdminDocID());
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
              animationController.forward();
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
          animation: animationController,
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
                            IconButton(
                              icon: Icon(MdiIcons.chevronLeft),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Finalize Order',
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
                                    strokeWidth: 3.0,
                                  )
                                : SizedBox.shrink(),
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
}
