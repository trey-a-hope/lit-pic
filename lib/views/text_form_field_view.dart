import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/services/validater_service.dart';

class TextFormFieldView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final TextEditingController textEditingController;
  final String labelText;
  final IconData iconData;
  final String Function(String) validator;
  final TextInputType keyboardType;

  TextFormFieldView(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.textEditingController,
      @required this.labelText,
      @required this.iconData,
      @required this.validator,
      @required this.keyboardType})
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
              child: TextFormField(
                validator: validator,
                keyboardType: keyboardType,
                textInputAction: TextInputAction.done,
                controller: textEditingController,
                style:
                    TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: labelText,
                    prefixIcon: Icon(iconData),
                    labelStyle: TextStyle(fontSize: 15)),
              )),
        );
      },
    );
  }
}
