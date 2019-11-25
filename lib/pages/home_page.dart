import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/views/detail_card_view.dart';
import 'package:litpic/views/recent_creations_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player/youtube_player.dart';

class HomePage extends StatefulWidget {
  final AnimationController animationController;

  const HomePage({Key key, this.animationController}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = List<Widget>();
  ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  final GetIt getIt = GetIt.I;
  User _currentUser;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  // Coupon _coupon;
  bool addAllListDataComplete = false;
  String youtubeVideoID;

  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
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
        widget: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
              'https://scontent-ort2-2.cdninstagram.com/vp/c21f18b9242101f4476511108371b153/5E892519/t51.2885-19/s320x320/60980291_2287245398154667_3908855079028916224_n.jpg?_nc_ht=scontent-ort2-2.cdninstagram.com'),
        ),
        image: Image.asset('assets/images/litpic_example.jpg'),
        subText: "Click here to follow.",
        title: 'What is a \"Lit Pic?\"',
        text:
            'A Lit Pic a 3D printed Lithophane, (created by tr3Designs), that you can display anywhere in your home to capture those special moments in your life. Each print comes with a stand and is measured to be between 8in high and 6in wide.',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
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
              parent: widget.animationController,
              curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
          animationController: widget.animationController,
        ),
      );
      listViews.add(
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: RecentCreationsView(
            mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / count) * 3, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.animationController,
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
      //Wait for user to be created in Auth to prevent error message.
      await Future.delayed(Duration(seconds: 3));

      //Load user.
      _currentUser = await getIt<AuthService>().getCurrentUser();

      //Request permission on iOS device.
      if (Platform.isIOS) {
        _fcm.requestNotificationPermissions(
          IosNotificationSettings(),
        );
      }

      //Update user's fcm token.
      final String fcmToken = await _fcm.getToken();
      if (fcmToken != null) {
        print(fcmToken);
        getIt<DBService>()
            .updateUser(userID: _currentUser.id, data: {'fcmToken': fcmToken});
      }

      //Configure notifications for several action types.
      _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          getIt<ModalService>().showAlert(
              context: context,
              title: message['notification']['title'],
              message: '');
        },
        onLaunch: (Map<String, dynamic> message) async {
          getIt<ModalService>().showAlert(
              context: context,
              title: message['notification']['title'],
              message: '');
        },
        onResume: (Map<String, dynamic> message) async {
          getIt<ModalService>().showAlert(
              context: context,
              title: message['notification']['title'],
              message: '');
        },
      );

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

  Future<void> fetchYouTubeVideoID() async {
    youtubeVideoID = await getIt<DBService>().retrieveYouTubeVideoID();
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
    List<Future> futures = List<Future>();
    futures.add(load());
    futures.add(fetchYouTubeVideoID());
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
              widget.animationController.forward();
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
          animation: widget.animationController,
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
