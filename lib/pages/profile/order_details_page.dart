import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/cart_item_model.dart';
import 'package:litpic/models/order_model.dart';
import 'package:litpic/models/sku_model.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/stripe_sku_service.dart';
import 'package:litpic/views/cart_item_bought_view.dart';
import 'package:litpic/views/simple_title_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../service_locator.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderModel order;
  const OrderDetailsPage({Key key, @required this.order}) : super(key: key);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState(order: order);
}

class _OrderDetailsPageState extends State<OrderDetailsPage>
    with TickerProviderStateMixin {
  final OrderModel order;

  _OrderDetailsPageState({@required this.order});
  AnimationController animationController;

  Animation<double> topBarAnimation;

  List<Widget> listViews = [];
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  bool addAllListDataComplete = false;
  bool fetchLithophaneSkuComplete = false;
  bool fetchCartItemsComplete = false;
  bool _isLoading = false;

  final String timeFormat = 'MMM d, yyyy @ h:mm a';
  SkuModel _sku;

  List<CartItemModel> cartItems = [];

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

      for (int i = 0; i < cartItems.length; i++) {
        listViews.add(
          Padding(
            padding: EdgeInsets.all(20),
            child: CartItemBoughtView(
              cartItem: cartItems[i],
              price: _sku.price,
              animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn))),
              animationController: animationController,
            ),
          ),
        );
      }

      listViews.add(
        SimpleTitleView(
          titleTxt: 'ID',
          subTxt: order.id,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Name',
          subTxt: order.shipping.name,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Address',
          subTxt: order.shipping.address.line1,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'City',
          subTxt: order.shipping.address.city,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'State',
          subTxt: order.shipping.address.state,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'ZIP',
          subTxt: order.shipping.address.postalCode,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Amount',
          subTxt: locator<FormatterService>().money(amount: order.amount),
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Quantity',
          subTxt: '${order.quantity}',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Carrier',
          subTxt:
              '${order.carrier == null ? 'Not Shipped Yet' : order.carrier}',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());
      listViews.add(
        SimpleTitleView(
          titleTxt: 'Tracking #',
          subTxt:
              '${order.trackingNumber == null ? 'Not Shipped Yet' : order.trackingNumber}',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Created',
          subTxt: DateFormat(timeFormat).format(order.created),
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Modified',
          subTxt: DateFormat(timeFormat).format(order.updated),
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );
    }
  }

  Future<void> fetchLithophaneSku() async {
    if (!fetchLithophaneSkuComplete) {
      fetchLithophaneSkuComplete = true;
      final String skuID = await locator<DBService>().retrieveSkuID();
      _sku = await locator<StripeSkuService>().retrieve(skuID: skuID);
      return;
    } else {
      return;
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

      //Fetch order that matches order id.
      QuerySnapshot orderQuerySnapshot = await Firestore.instance
          .collection('Orders')
          .where('id', isEqualTo: order.id)
          .getDocuments();

      //Fetch cart items for that order.
      DocumentSnapshot cartItemDoc = orderQuerySnapshot.documents.first;
      QuerySnapshot cartItemsSnapshot = await Firestore.instance
          .collection('Orders')
          .document(cartItemDoc.documentID)
          .collection('Cart Items')
          .getDocuments();
      List<DocumentSnapshot> cartItemDocs = cartItemsSnapshot.documents;

      //Add cart items to list.
      for (int i = 0; i < cartItemDocs.length; i++) {
        cartItems.add(
          CartItemModel.fromDoc(doc: cartItemDocs[i]),
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
    futures.add(fetchLithophaneSku());
    futures.add(fetchCartItems());
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
                                  'Order Details',
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
