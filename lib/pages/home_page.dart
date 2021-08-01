import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/mixins/ui_properties_mixin.dart';
import 'package:litpic/models/litpic_model.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/litpic_service.dart';
import 'package:litpic/services/user_service.dart';
import 'package:litpic/views/detail_card_view.dart';
import 'package:litpic/views/recent_creations_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage() : super();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, UIPropertiesMixin {
  // late Animation<double> topBarAnimation;

  // List<Widget> listViews = [];
  // ScrollController scrollController = ScrollController();
  // double topBarOpacity = 0.0;

  late UserModel _currentUser;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool addAllListDataComplete = false;
  List<LitPicModel> litPics = [];

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

  @override
  void dispose() {
    super.dispose();
  }

  void addAllListData() {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;
      var count = 6;
      listViews.add(DetailCardView(
        onTap: () async {
          const url = 'https://www.instagram.com/tr3.designs/?hl=en';
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        widget: Icon(Icons.print),
        image: Image.asset('assets/images/litpic_example.jpg'),
        subText: "Click here to follow.",
        title: 'What is a \"Lit Pic?\"',
        text:
            'A Lit Pic a 3D printed Lithophane, (created by tr3Designs), that you can display anywhere in your home to capture those special moments in your life. Each print comes with a stand and is measured to be between 8in high and 6in wide.',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ));

      // listViews.add(
      //   TitleView(
      //     showExtra: false,
      //     titleTxt: 'Watch how it\'s done',
      //     subTxt: 'Details',
      //     animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      //         parent: widget.animationController,
      //         curve:
      //             Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
      //     animationController: widget.animationController,
      //   ),
      // );

      // YoutubePlayerController youtubePlayerController = YoutubePlayerController(
      //   initialVideoId: youtubeVideoID,
      //   flags: YoutubePlayerFlags(
      //     autoPlay: true,
      //     mute: false,
      //   ),
      // );
      // listViews.add(
      //   Padding(
      //     padding: EdgeInsets.all(20),
      //     child: YoutubePlayer(
      //       controller: youtubePlayerController,
      //       showVideoProgressIndicator: true,
      //       progressIndicatorColor: Colors.amber,
      //       progressColors: ProgressBarColors(
      //         playedColor: Colors.amber,
      //         handleColor: Colors.amberAccent,
      //       ),
      //       onReady: () {
      //         youtubePlayerController.play();
      //       },
      //     ),
      //   ),
      // );

      // listViews.add(
      //   Padding(
      //     padding: EdgeInsets.all(20),
      //     child: YoutubePlayer(
      //       context: context,
      //       source: youtubeVideoID,
      //       quality: YoutubeQuality.HD,
      //       // callbackController is (optional).
      //       // use it to control player on your own.
      //       // callbackController: (controller) {
      //       //   _videoController = controller;
      //       // },
      //     ),
      //   ),
      // );

      listViews.add(
        TitleView(
          showExtra: false,
          titleTxt: 'Recent creations',
          subTxt: 'Details',
          animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: animationController,
        ),
      );
      listViews.add(
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: RecentCreationsView(
            litPics: litPics,
            animation: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve:
                    Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn),
              ),
            ),
            animationController: animationController,
          ),
        ),
      );

      // listViews.add(
      //   TitleView(
      //     titleTxt: 'Monthly Coupon',
      //     subTxt: 'Customize',
      //     animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      //         parent: widget.animationController,
      //         curve:
      //             Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
      //     animationController: widget.animationController,
      //   ),
      // );
      // listViews.add(
      //   MonthlyCouponView(
      //     coupon: _coupon,
      //     animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      //         parent: widget.animationController,
      //         curve:
      //             Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
      //     animationController: widget.animationController,
      //   ),
      // );
    }
  }

  Future<void> load() async {
    try {
      //Load user.
      _currentUser = await locator<AuthService>().getCurrentUser();

      //Request permission on iOS device.
      if (Platform.isIOS) {
        _fcm.requestPermission();
      }

      //Update user's fcm token.
      final String? fcmToken = await _fcm.getToken();
      if (fcmToken != null) {
        locator<UserService>()
            .updateUser(uid: _currentUser.uid, data: {'fcmToken': fcmToken});
      }

      //Configure notifications for several action types.
      // _fcm.configure(
      //   onMessage: (Map<String, dynamic> message) async {
      //     print("onMessage: $message");
      //     locator<ModalService>().showAlert(
      //         context: context,
      //         title: message['notification']['title'],
      //         message: '');
      //   },
      //   onLaunch: (Map<String, dynamic> message) async {
      //     locator<ModalService>().showAlert(
      //         context: context,
      //         title: message['notification']['title'],
      //         message: '');
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     locator<ModalService>().showAlert(
      //         context: context,
      //         title: message['notification']['title'],
      //         message: '');
      //   },
      // );

      return;
    } catch (e) {
      return;
    }
  }

  Future<void> fetchLitPics() async {
    litPics = await locator<LitPicService>().retrieveLitPics();
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
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    List<Future> futures = [];
    futures.add(load());
    futures.add(fetchLitPics());
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Lit Pic",
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
}
