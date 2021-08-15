import 'package:flutter/material.dart';
import 'package:litpic/common/hero_screen.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/display_item_model.dart';
import 'package:litpic/services/formatter_service.dart';

import '../service_locator.dart';

class DisplayItemView extends StatelessWidget {
  final DisplayItemModel displayItem;
  final AnimationController animationController;
  final Animation<double> animation;

  DisplayItemView({
    required this.displayItem,
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
            child: InkWell(
              splashColor: Colors.transparent,
              child: SizedBox(
                height: 120,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 72,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  '3D Printed Lithophane',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color:
                                                        LitPicTheme.darkerText,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          // Expanded(
                                          //   child: SizedBox(),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Quanity: ${displayItem.quantity}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: LitPicTheme.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8, right: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  locator<FormatterService>()
                                                      .money(
                                                    amount: displayItem.amount *
                                                        displayItem.quantity,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.27,
                                                    color:
                                                        LitPicTheme.nearlyBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) {
                                        return HeroScreen(
                                          imgUrl: displayItem.custom.images[0],
                                          imgPath: null,
                                        );
                                      }),
                                    );
                                  },
                                  child: Hero(
                                    tag: displayItem.custom.images[0],
                                    child: Image.network(
                                      displayItem.custom.images[0],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
