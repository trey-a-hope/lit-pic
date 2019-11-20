import 'package:flutter/material.dart';
import 'package:litpic/litpic_theme.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation animation;
  final bool showExtra;
  final VoidCallback showExtraOnTap;

  TitleView(
      {Key key,
      @required this.titleTxt,
      @required this.subTxt,
      @required this.animationController,
      @required this.animation,
      @required this.showExtra,
      this.showExtraOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleTxt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: LitPicTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: LitPicTheme.lightText,
                        ),
                      ),
                    ),
                    showExtra
                        ? InkWell(
                            highlightColor: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            onTap: showExtraOnTap,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    subTxt,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: LitPicTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      color: LitPicTheme.nearlyDarkBlue,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 38,
                                    width: 26,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: LitPicTheme.darkText,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
