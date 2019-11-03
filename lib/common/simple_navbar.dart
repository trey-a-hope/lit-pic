import 'package:flutter/material.dart';

class SimpleNavbar extends StatelessWidget {
  final Widget leftWidget, rightWidget;
  final Function leftTap, rightTap;

  SimpleNavbar({Key key, this.leftWidget, this.leftTap, this.rightWidget, this.rightTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 30, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: Padding(padding: EdgeInsets.all(10), child: leftWidget),
            onTap: leftTap,
          ),
          InkWell(
            child: Padding(padding: EdgeInsets.all(10), child: rightWidget),
            onTap: rightTap,
          ),
        ],
      ),
    );
  }
}
