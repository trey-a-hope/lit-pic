import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/asset_images.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe_card_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/services/stripe_token_service.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/text_form_field_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../service_locator.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({Key key}) : super(key: key);
  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> topBarAnimation;

  List<Widget> listViews = [];
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final Color iconColor = Colors.amber[700];

  UserModel _currentUser;

  bool addAllListDataComplete = false;

  bool _isLoading = false;

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

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

      listViews.add(Padding(
        padding: EdgeInsets.all(20),
        child: creditCard,
      ));

      listViews.add(
        Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.number,
                  textEditingController: _cardNumberController,
                  validator: locator<ValidatorService>().cardNumber,
                  labelText: 'Card Number',
                  iconData: MdiIcons.creditCard,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 0, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.number,
                  textEditingController: _expirationController,
                  validator: locator<ValidatorService>().cardExpiration,
                  labelText: 'Expiration',
                  iconData: Icons.date_range,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 2, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.number,
                  textEditingController: _cvcController,
                  validator: locator<ValidatorService>().cardCVC,
                  labelText: 'CVC',
                  iconData: MdiIcons.security,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 4, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
            ],
          ),
        ),
      );

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: RoundButtonView(
            buttonColor: Colors.green,
            textColor: Colors.white,
            onPressed: _addTestCardInfo,
            text: 'ADD TEST CARD (DEMO ONLY)',
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
          ),
        ),
      );

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: RoundButtonView(
            buttonColor: Colors.amber,
            textColor: Colors.white,
            onPressed: _submitCard,
            text: 'SAVE',
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
          ),
        ),
      );
    }
  }

  Future<void> loadCustomerInfo() async {
    try {
      //Load user and orders.
      _currentUser = await locator<AuthService>().getCurrentUser();
      _currentUser.customer = await locator<StripeCustomerService>()
          .retrieve(customerID: _currentUser.customerID);

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

  void _submitCard() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      bool confirm = await locator<ModalService>().showConfirmation(
          context: context, title: 'Add Card', message: 'Are you sure?');
      if (confirm) {
        setState(
          () {
            _isLoading = true;
          },
        );

        String number = _cardNumberController.text;
        String expMonth = _expirationController.text.substring(0, 2);
        String expYear = _expirationController.text.substring(2, 4);
        String cvc = _cvcController.text;

        try {
          String token = await locator<StripeTokenService>().create(
              number: number, expMonth: expMonth, expYear: expYear, cvc: cvc);

          await locator<StripeCardService>()
              .create(customerID: _currentUser.customerID, token: token);

          print(token);

          setState(
            () {
              _isLoading = false;
            },
          );
          _clearForm();
          locator<ModalService>().showAlert(
              context: context,
              title: 'Success',
              message: 'Card added successfully.');
        } catch (e) {
          setState(
            () {
              _isLoading = false;
            },
          );
          locator<ModalService>().showAlert(
              context: context,
              title: 'Error',
              message: 'Could not save card at this time.');
        }
      }
    }
  }

  void _addTestCardInfo() {
    _cardNumberController.text = '4242424242424242';
    _expirationController.text = '0621';
    _cvcController.text = '323';
    _autoValidate = true;
  }

  void _clearForm() {
    _cardNumberController.clear();
    _expirationController.clear();
    _cvcController.clear();
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
                                  'Add Card',
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
                                : SizedBox.shrink()
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
