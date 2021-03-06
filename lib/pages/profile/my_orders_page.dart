import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/order_model.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/pages/profile/order_details_page.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/order_service.dart';
import 'package:litpic/services/stripe_session_service.dart';
import 'package:litpic/views/list_tile_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyOrdersPage extends StatefulWidget {
  final String status;

  const MyOrdersPage({required this.status}) : super();

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> topBarAnimation;

  List<Widget> listViews = [];
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final Color iconColor = Colors.amber[700]!;

  late UserModel _currentUser;
  List<OrderModel> orders = [];

  bool addAllListDataComplete = false;

  bool _isLoading = false;

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
        _isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.blue[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              )
            : SizedBox.shrink(),
      );

      if (orders.isEmpty) {
        listViews.add(
          TitleView(
            showExtra: false,
            titleTxt:
                'No ${widget.status == 'created' ? 'open' : 'complete'} orders.',
            subTxt: '',
            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 0, 1.0,
                    curve: Curves.fastOutSlowIn))),
            animationController: animationController,
          ),
        );
      } else {
        //Iterate through each order.
        for (int i = 0; i < orders.length; i++) {
          OrderModel order = orders[i];

          listViews.add(
            ListTileView(
              icon: Icon(
                MdiIcons.creditCardClock,
                color: Colors.purple,
              ),
              title: 'ID: ${order.id}',
              subTitle:
                  'Created: ${DateFormat(timeFormat).format(order.created)}',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(order: order),
                  ),
                );
              },
              animation: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 0, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              ),
              animationController: animationController,
            ),
          );
        }
      }
    }
  }

  Future<void> loadCustomerInfo() async {
    try {
      //Load user and orders.
      _currentUser = await locator<AuthService>().getCurrentUser();
      orders = await locator<OrderService>()
          .list(customerID: _currentUser.customerID, status: widget.status);

      //Apply session to each order.
      for (int i = 0; i < orders.length; i++) {
        OrderModel order = orders[i];

        order.session = await locator<StripeSessionService>()
            .retrieve(sessionID: order.sessionID);
      }

      return;
    } catch (e) {
      locator<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
      return;
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
    futures.add(loadCustomerInfo());
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
                                  '${widget.status == 'created' ? 'Open' : 'Complete'} Orders',
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
