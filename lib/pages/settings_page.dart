import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/mixins/ui_properties_mixin.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/views/list_tile_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service_locator.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage() : super();
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin, UIPropertiesMixin {
  // late Animation<double> topBarAnimation;

  // List<Widget> listViews = [];
  // var scrollController = ScrollController();
  // double topBarOpacity = 0.0;

  final Color iconColor = Colors.amber[700]!;
  // late UserModel _currentUser;
  bool addAllListDataComplete = false;

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
      int count = 3;

      //Go To Website
      listViews.add(
        ListTileView(
          animationController: animationController,
          animation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          icon: Icon(
            MdiIcons.web,
            color: iconColor,
          ),
          title: 'Go To Website',
          subTitle: 'View our privacy-policy, support info, and more.',
          onTap: () async {
            var url = 'https://litpic-f293c.firebaseapp.com/';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              locator<ModalService>().showAlert(
                  context: context,
                  title: 'Error',
                  message: 'Could not launch $url.');
            }
          },
        ),
      );

      //Delete Account
      listViews.add(
        ListTileView(
          animationController: animationController,
          animation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          icon: Icon(
            MdiIcons.delete,
            color: iconColor,
          ),
          title: 'Delete Account',
          subTitle: 'Remove account from this app.',
          onTap: () async {
            bool confirm = await locator<ModalService>().showConfirmation(
                context: context,
                title: 'Delete Account',
                message: 'Are you sure?');

            if (!confirm) return;

            String? password = await locator<ModalService>().showInputDialog(
                context: context,
                title: 'Enter your password.',
                hintText: 'Password...');

            if (password == null) return;

            UserModel currentUser =
                await locator<AuthService>().getCurrentUser();

            try {
              //Delete user from Firestore and Auth.
              await locator<AuthService>().deleteUser(password: password);

              //Delete user from Stripe.
              await locator<StripeCustomerService>()
                  .delete(customerID: currentUser.customerID);

              //Log user out.
              await locator<AuthService>().signOut();
            } on PlatformException catch (e) {
              locator<ModalService>().showAlert(
                  context: context, title: 'Error', message: e.message!);
            }
          },
        ),
      );

      //Sign Out
      listViews.add(
        ListTileView(
          animationController: animationController,
          animation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn),
            ),
          ),
          icon: Icon(
            MdiIcons.logout,
            color: iconColor,
          ),
          title: 'Sign Out',
          subTitle: 'Exit account temporarily.',
          onTap: () async {
            bool confirm = await locator<ModalService>().showConfirmation(
                context: context, title: 'Sign Out', message: 'Are you sure?');
            if (confirm) {
              await locator<AuthService>().signOut();
            }
          },
        ),
      );
    }
  }

  // Future<void> load() async {
  //   try {
  //     //Load user.
  //     _currentUser = await locator<AuthService>().getCurrentUser();
  //     return;
  //   } on PlatformException catch (e) {
  //     return locator<ModalService>()
  //         .showAlert(context: context, title: 'Error', message: e.message!);
  //   }
  // }

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
    // futures.add(load());
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Settings",
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
}
