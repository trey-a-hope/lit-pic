import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/display_item_model.dart';
import 'package:litpic/models/order_model.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/stripe_payment_intent_service.dart';
import 'package:litpic/views/display_item_view.dart';
import 'package:litpic/views/simple_title_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderDetailsPage extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsPage({required this.order}) : super();

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> topBarAnimation;

  List<Widget> listViews = [];
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  bool addAllListDataComplete = false;
  // bool fetchLithophaneSkuComplete = false;
  // bool fetchCartItemsComplete = false;

  // final String timeFormat = 'MMM d, yyyy @ h:mm a';
  // late SkuModel _sku;

  // List<CartItemModel> cartItems = [];

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

  Future<void> load() async {
    final String paymentIntentID = widget.order.session!.paymentIntentID!;

    widget.order.session!.paymentIntent =
        await locator<StripePaymentIntentService>()
            .retrieve(paymentIntentID: paymentIntentID);

    return;
  }

  void addAllListData() {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;
      var count = 5;

      listViews.add(
        SimpleTitleView(
          titleTxt: 'ID',
          subTxt: widget.order.id,
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
          subTxt: widget.order.shipping.name,
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
          subTxt: widget.order.shipping.address.line1,
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
          subTxt: widget.order.shipping.address.city,
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
          subTxt: widget.order.shipping.address.state,
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
          subTxt: widget.order.shipping.address.postalCode,
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(Divider());

      for (int i = 0; i < widget.order.session!.displayItems!.length; i++) {
        DisplayItemModel displayItem = widget.order.session!.displayItems![i];

        listViews.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: DisplayItemView(
              displayItem: displayItem,
              animation: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              ),
              animationController: animationController,
            ),
          ),
        );

        // listViews.add(
        //   SimpleTitleView(
        //     titleTxt: ' Amount',
        //     subTxt:
        //         locator<FormatterService>().money(amount: displayItem.amount),
        //     animation: Tween(begin: 0.0, end: 1.0).animate(
        //       CurvedAnimation(
        //           parent: animationController,
        //           curve: Interval((1 / count) * 0, 1.0,
        //               curve: Curves.fastOutSlowIn)),
        //     ),
        //     animationController: animationController,
        //   ),
        // );
      }

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Total Amount',
          subTxt: locator<FormatterService>()
              .money(amount: widget.order.session!.paymentIntent!.amount),
          animation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 0, 1.0,
                    curve: Curves.fastOutSlowIn)),
          ),
          animationController: animationController,
        ),
      );

      // listViews.add(
      //   SimpleTitleView(
      //     titleTxt: 'Quantity',
      //     subTxt: '${order.quantity}',
      //     animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      //         parent: animationController,
      //         curve:
      //             Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
      //     animationController: animationController,
      //   ),
      // );

      listViews.add(Divider());

      listViews.add(
        SimpleTitleView(
          titleTxt: 'Carrier',
          subTxt:
              '${widget.order.carrier == null ? 'Not Shipped Yet' : widget.order.carrier}',
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
              '${widget.order.trackingNumber == null ? 'Not Shipped Yet' : widget.order.trackingNumber}',
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
          subTxt: DateFormat(timeFormat).format(widget.order.created),
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
          subTxt: DateFormat(timeFormat).format(widget.order.modified),
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );
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
    List<Future> futures = [];
    // futures.add(fetchLithophaneSku());
    futures.add(load());
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
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
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
