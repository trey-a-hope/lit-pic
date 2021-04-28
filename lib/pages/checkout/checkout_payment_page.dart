import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/models/stripe/credit_card.dart';
import 'package:litpic/pages/checkout/checkout_final_page.dart';
import 'package:litpic/pages/profile/saved_cards_page.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/views/credit_card_view.dart';
import 'package:litpic/views/pay_flow_diagram_view.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CheckoutPaymentPage extends StatefulWidget {
  const CheckoutPaymentPage({Key key}) : super(key: key);
  @override
  _CheckoutPaymentPageState createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage>
    with TickerProviderStateMixin {
  AnimationController animationController;

  Animation<double> topBarAnimation;

  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final GetIt getIt = GetIt.I;

  User _currentUser;

  bool loadCustomerInfoComplete = false;
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
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
          child: PayFlowDiagramView(
            paymentComplete: false,
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

      listViews.add(
        TitleView(
          showExtraOnTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                return SavedCardsPage();
              }),
            );
          },
          showExtra: true,
          titleTxt: 'Default Card',
          subTxt: 'Edit',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      if (_currentUser.customer.sources.isEmpty) {
        listViews.add(
          TitleView(
            titleTxt: 'No Saved Cards',
            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 0, 1.0,
                    curve: Curves.fastOutSlowIn))),
            animationController: animationController,
            showExtra: false,
            subTxt: '',
          ),
        );
      } else {
        CreditCard creditCard = _currentUser.customer.card;
        listViews.add(
          CreditCardView(
            deleteCard: () async {
              getIt<ModalService>().showAlert(
                  context: context,
                  title: 'Error',
                  message: 'Click edit to make changes to this card.');
            },
            makeDefaultCard: () async {
              getIt<ModalService>().showAlert(
                  context: context,
                  title: 'Error',
                  message: 'Click edit to make changes to this card.');
            },
            isDefault: true,
            creditCard: creditCard,
            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 0, 1.0,
                    curve: Curves.fastOutSlowIn))),
            animationController: animationController,
          ),
        );
      }

      if (_currentUser.customer.sources.isNotEmpty) {
        listViews.add(
          Padding(
            padding: EdgeInsets.all(20),
            child: RoundButtonView(
              buttonColor: Colors.amber,
              text: 'FINALIZE ORDER',
              textColor: Colors.white,
              animation: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 3, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              ),
              animationController: animationController,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return CheckoutFinalPage();
                  }),
                );
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> loadCustomerInfo() async {
    if (!loadCustomerInfoComplete) {
      loadCustomerInfoComplete = true;

      try {
        //Load user and orders.
        _currentUser = await getIt<AuthService>().getCurrentUser();
        _currentUser.customer = await getIt<StripeCustomerService>()
            .retrieve(customerID: _currentUser.customerID);

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
                                  'Choose Payment',
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
                                : IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                        listViews.clear();
                                      });

                                      //Re add views with new data.
                                      loadCustomerInfoComplete = false;
                                      await loadCustomerInfo();

                                      //Re add views with new data.
                                      addAllListDataComplete = false;
                                      addAllListData();

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    },
                                    icon: Icon(Icons.refresh),
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
