import 'package:flutter/material.dart';

class GoodButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color buttonColor;
  final Color textColor;

  GoodButton({Key key, @required this.onPressed, @required this.text, @required this.buttonColor, @required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
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
    );
  }
}
