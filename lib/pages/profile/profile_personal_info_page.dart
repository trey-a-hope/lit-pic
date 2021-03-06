import 'package:flutter/material.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/pages/profile/edit_basic_info_page.dart';
import 'package:litpic/pages/profile/edit_shipping_info_page.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/views/data_box_view.dart';
import 'package:litpic/views/simple_title_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../service_locator.dart';

class ProfilePersonalInfoPage extends StatefulWidget {
  const ProfilePersonalInfoPage(
      //Key key
      )
      : super();
  @override
  _ProfilePersonalInfoPageState createState() =>
      _ProfilePersonalInfoPageState();
}

class _ProfilePersonalInfoPageState extends State<ProfilePersonalInfoPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> topBarAnimation;

  List<Widget> listViews = [];
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final Color iconColor = Colors.amber[700]!;

  late UserModel _currentUser;
  bool _isLoading = false;

  bool loadCustomerInfoComplete = false;
  bool addAllListDataComplete = false;

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
        TitleView(
          showExtraOnTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                return EditBasicInfoPage();
              }),
            );
          },
          showExtra: true,
          titleTxt: 'Basic',
          subTxt: 'Edit',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      listViews.add(
        Padding(
          padding: EdgeInsets.all(10),
          child: DataBoxView(
            dataBoxChildren: [
              DataBoxChild(
                  iconData: Icons.face,
                  text: 'Name',
                  subtext: _currentUser.customer!.name,
                  color: Colors.red),
              DataBoxChild(
                  iconData: Icons.email,
                  text: 'Email',
                  subtext: _currentUser.customer!.email,
                  color: Colors.red),
            ],
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
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
                return EditShippingInfoPage();
              }),
            );
          },
          showExtra: true,
          titleTxt: 'Shipping',
          subTxt: 'Edit',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );

      if (_currentUser.customer!.shipping == null) {
        listViews.add(
          SimpleTitleView(
            titleTxt: 'Currently no shipping info.',
            subTxt: '',
            animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 2, 1.0,
                    curve: Curves.fastOutSlowIn))),
            animationController: animationController,
          ),
        );
      } else {
        listViews.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: DataBoxView(
              dataBoxChildren: [
                DataBoxChild(
                    iconData: Icons.location_on,
                    text: 'Address',
                    subtext: _currentUser.customer!.shipping!.address.line1,
                    color: Colors.amber),
                DataBoxChild(
                    iconData: Icons.location_city,
                    text: 'City',
                    subtext: _currentUser.customer!.shipping!.address.city,
                    color: Colors.amber),
                DataBoxChild(
                    iconData: Icons.my_location,
                    text: 'State',
                    subtext: _currentUser.customer!.shipping!.address.state,
                    color: Colors.amber),
                DataBoxChild(
                    iconData: Icons.contact_mail,
                    text: 'ZIP',
                    subtext:
                        _currentUser.customer!.shipping!.address.postalCode,
                    color: Colors.amber)
              ],
              animation: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 3, 1.0,
                      curve: Curves.fastOutSlowIn),
                ),
              ),
              animationController: animationController,
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
        //Load user.
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
                                  "Personal Info",
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

                                      //Re add views with  data.
                                      loadCustomerInfoComplete = false;
                                      await loadCustomerInfo();

                                      //Re add views with  data.
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
