import 'package:flutter/material.dart';
import 'package:litpic/common/hero_screen.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/litpic_model.dart';

class RecentCreationsView extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final List<LitPicModel> litPics;

  const RecentCreationsView(
      { //Key key,
      required this.animationController,
      required this.animation,
      required this.litPics})
      : super();
  @override
  _RecentCreationsViewState createState() =>
      _RecentCreationsViewState(litPics: this.litPics);
}

class _RecentCreationsViewState extends State<RecentCreationsView>
    with TickerProviderStateMixin {
  _RecentCreationsViewState({required this.litPics});
  late AnimationController animationController;
  final List<LitPicModel> litPics;

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
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: litPics.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var count = litPics.length > 10 ? 10 : litPics.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return LitPicView(
                    litPic: litPics[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class LitPicView extends StatelessWidget {
  final LitPicModel litPic;
  final AnimationController animationController;
  final Animation<double> animation;

  const LitPicView({
    //Key key,
    required this.litPic,
    required this.animationController,
    required this.animation,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              offset: Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            LitPicTheme.nearlyDarkBlue,
                            LitPicTheme.nearlyDarkBlue.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              litPic.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: LitPicTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: LitPicTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      litPic.dimensions,
                                      style: TextStyle(
                                        fontFamily: LitPicTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: LitPicTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  litPic.printMinutes.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: LitPicTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    letterSpacing: 0.2,
                                    color: LitPicTheme.white,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, bottom: 3),
                                  child: Text(
                                    'min',
                                    style: TextStyle(
                                      fontFamily: LitPicTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      letterSpacing: 0.2,
                                      color: LitPicTheme.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) {
                            return HeroScreen(
                                imgUrl: litPic.imgUrl, imgPath: null);
                          }),
                        );
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Hero(
                                  tag: 'a',
                                  child: Image.network(
                                    litPic.imgUrl,
                                    scale: 10,
                                    repeat: ImageRepeat.noRepeat,
                                  ) // Image.network(litPic.imgUrl),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
