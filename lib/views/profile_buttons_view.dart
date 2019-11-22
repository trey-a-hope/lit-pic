
import 'package:flutter/material.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/pages/my_complete_orders_page.dart';
import 'package:litpic/pages/my_open_orders_page.dart';
import 'package:litpic/pages/saved_cards_page.dart';
import 'package:litpic/pages/profile_personal_info_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileButtonsView extends StatefulWidget {
  final AnimationController mainScreenAnimationController;
  final Animation mainScreenAnimation;

  const ProfileButtonsView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);
  @override
  _ProfileButtonsViewState createState() => _ProfileButtonsViewState();
}

class _ProfileButtonsViewState extends State<ProfileButtonsView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<ProfileBoxModel> profileBoxModels;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    profileBoxModels = [
      ProfileBoxModel(
          title: 'Personal Info',
          icon: Icon(
            MdiIcons.face,
            color: Colors.amber,
            size: 40,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                return ProfilePersonalInfoPage();
              }),
            );
          }),
      ProfileBoxModel(
          title: 'Saved Cards',
          icon: Icon(
            MdiIcons.creditCard,
            color: Colors.blue,
            size: 40,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                return SavedCardsPage();
              }),
            );
          }),
      ProfileBoxModel(
          title: 'Open Orders',
          icon: Icon(
            MdiIcons.mailboxOpen,
            color: Colors.purple,
            size: 40,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                return MyOpenOrdersPage();
              }),
            );
          }),
      ProfileBoxModel(
          title: 'Complete Orders',
          icon: Icon(
            MdiIcons.mailboxUp,
            color: Colors.green,
            size: 40,
          ),          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) {
                return MyCompleteOrdersPage();
              }),
            );
          }),
    ];

    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    profileBoxModels.length,
                    (index) {
                      var count = profileBoxModels.length;
                      var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController.forward();
                      return ProfileBoxView(
                        profileBoxModel: profileBoxModels[index],
                        animation: animation,
                        animationController: animationController,
                      );
                    },
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileBoxView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final ProfileBoxModel profileBoxModel;

  const ProfileBoxView(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.profileBoxModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Radius borderRadius = Radius.circular(8.0);

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: LitPicTheme.white,
                borderRadius: BorderRadius.only(
                    topLeft: borderRadius,
                    bottomLeft: borderRadius,
                    bottomRight: borderRadius,
                    topRight: borderRadius),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: LitPicTheme.grey.withOpacity(0.4),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    splashColor: LitPicTheme.nearlyDarkBlue.withOpacity(0.2),
                    onTap: profileBoxModel.onTap,
                    child: Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            profileBoxModel.icon,
                            // Icon(
                            //   profileBoxModel.iconData,
                            //   color: Colors.grey,
                            //   size: 40,
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(profileBoxModel.title)
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileBoxModel {
  final String title;
  final VoidCallback onTap;
  final Icon icon;

  ProfileBoxModel(
      {@required this.title, @required this.onTap, @required this.icon});
}
