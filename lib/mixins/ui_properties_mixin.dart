import 'package:flutter/material.dart';

mixin UIPropertiesMixin {
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<Widget> listViews = [];
  Animation<double> topBarAnimation;
  AnimationController animationController;
}
