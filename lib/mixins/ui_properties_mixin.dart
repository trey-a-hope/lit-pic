import 'package:flutter/material.dart';

mixin UIPropertiesMixin {
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<Widget> listViews = [];
  late Animation<double> topBarAnimation;
  late AnimationController animationController;
}
