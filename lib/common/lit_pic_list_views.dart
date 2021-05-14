import 'package:flutter/material.dart';

class LitPicListViews extends StatelessWidget {
  final ScrollController scrollController;
  final AnimationController animationController;
  final List<Widget> listViews;

  LitPicListViews({
    Key key,
    @required this.scrollController,
    @required this.animationController,
    @required this.listViews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
