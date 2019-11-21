import 'package:flutter/material.dart';

class ListTileView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final Icon icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;

  ListTileView(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.icon,
      @required this.title,
      @required this.subTitle,
      @required this.onTap})
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
            child: ListTile(
              leading: icon,
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                subTitle,
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }
}
