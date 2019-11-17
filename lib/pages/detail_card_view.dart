import 'package:flutter/material.dart';
import 'package:litpic/asset_images.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DetailCardView extends StatelessWidget {
  final VoidCallback callback;
  // final HotelListData hotelData;
  final AnimationController animationController;
  final Animation animation;
  final Image image;
  final String title;
  final String text;
  final String subText;
  final Widget widget;

  const DetailCardView(
      {Key key,
      this.animationController,
      @required this.image,
      @required this.title,
      @required this.text,
      @required this.subText,
      @required this.widget,
      this.animation,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2, //1000px x 500px
                              child: image,
                            ),
                            Container(
                              color: LitPicTheme.background,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(text),
  
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    subText,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, top: 8),
                                    child: widget,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Positioned(
                        //   top: 8,
                        //   right: 8,
                        //   child: Material(
                        //     color: Colors.transparent,
                        //     child: InkWell(
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(32.0),
                        //       ),
                        //       onTap: () {},
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Icon(
                        //           Icons.favorite_border,
                        //           color: Colors.black,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
