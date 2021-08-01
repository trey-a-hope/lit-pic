import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/text_form_field_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../service_locator.dart';

class EditShippingInfoPage extends StatefulWidget {
  const EditShippingInfoPage() : super();
  @override
  _EditShippingInfoPageState createState() => _EditShippingInfoPageState();
}

class _EditShippingInfoPageState extends State<EditShippingInfoPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> topBarAnimation;

  List<Widget> listViews = [];
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final Color iconColor = Colors.amber[700]!;

  late UserModel _currentUser;

  bool addAllListDataComplete = false;
  bool loadCustomerInfoComplete = false;

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  bool _isLoading = false;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
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

  void addAllListData() {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;
      var count = 5;

      listViews.add(
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.text,
                  labelText: 'Address',
                  validator: locator<ValidatorService>().isEmpty,
                  textEditingController: _addressController,
                  iconData: Icons.location_on,
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
                  keyboardType: TextInputType.text,
                  labelText: 'City',
                  validator: locator<ValidatorService>().isEmpty,
                  textEditingController: _cityController,
                  iconData: Icons.location_city,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  animationController: animationController,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: TextFormFieldView(
                  keyboardType: TextInputType.text,
                  labelText: 'State',
                  validator: locator<ValidatorService>().state,
                  textEditingController: _stateController,
                  iconData: Icons.my_location,
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
                  labelText: 'ZIP',
                  validator: locator<ValidatorService>().zip,
                  textEditingController: _zipController,
                  iconData: Icons.contact_mail,
                  animation: Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * 3, 1.0,
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
            buttonColor: Colors.amber,
            textColor: Colors.white,
            onPressed: _save,
            text: 'SAVE',
            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 4, 1.0,
                    curve: Curves.fastOutSlowIn))),
            animationController: animationController,
          ),
        ),
      );
    }
  }

  Future<void> loadCustomerInfo() async {
    if (!loadCustomerInfoComplete) {
      loadCustomerInfoComplete = true;

      try {
        //Load user.
        _currentUser = await locator<AuthService>().getCurrentUser();
        _currentUser.customer = await locator<StripeCustomerService>()
            .retrieve(customerID: _currentUser.customerID);

        if (_currentUser.customer!.shipping != null) {
          _addressController.text =
              _currentUser.customer!.shipping!.address.line1;
          _cityController.text = _currentUser.customer!.shipping!.address.city;
          _stateController.text =
              _currentUser.customer!.shipping!.address.state;
          _zipController.text =
              _currentUser.customer!.shipping!.address.postalCode;
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
  }

  _save() async {
    if (_formKey.currentState!.validate()) {
      bool confirm = await locator<ModalService>().showConfirmation(
          context: context, title: 'Submit', message: 'Are you sure?');
      if (confirm) {
        _formKey.currentState!.save();

        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          //Update address info.
          await locator<StripeCustomerService>().update(
              name: _currentUser.customer!.name,
              customerID: _currentUser.customerID,
              line1: _addressController.text,
              city: _cityController.text,
              state: _stateController.text.toUpperCase(),
              postalCode: _zipController.text,
              country: 'US');

          setState(
            () {
              _isLoading = false;
            },
          );
          locator<ModalService>().showAlert(
            context: context,
            title: 'Success',
            message: 'Shipping Info Updated',
          );
        } on PlatformException catch (e) {
          setState(
            () {
              _isLoading = false;
            },
          );
          locator<ModalService>().showAlert(
            context: context,
            title: 'Error',
            message: e.message!,
          );
        }
      } else {
        setState(
          () {
            _autoValidate = true;
          },
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
                                  'Edit Shipping Info',
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
