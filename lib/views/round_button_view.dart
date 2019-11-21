import 'package:flutter/material.dart';

class RoundButtonView extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color buttonColor;
  final Color textColor;
  final AnimationController animationController;
  final Animation animation;

  RoundButtonView(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.onPressed,
      @required this.text,
      @required this.buttonColor,
      @required this.textColor})
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
              child: MaterialButton(
                onPressed: onPressed,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'SFUIDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: buttonColor,
                elevation: 0,
                minWidth: 400,
                height: 50,
                textColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
        );
      },
    );
  }
}
