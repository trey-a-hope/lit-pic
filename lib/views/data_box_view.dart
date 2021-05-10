import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:litpic/litpic_theme.dart';

class DataBoxData {
  final List<DataBoxChild> dataBoxes;
  DataBoxData({@required this.dataBoxes});
}

class DataBoxChild {
  final String subtext;
  final String text;
  final Color color;
  final IconData iconData;
  DataBoxChild(
      {@required this.text,
      @required this.subtext,
      @required this.color,
      @required this.iconData});
}

class DataBoxChildView extends StatelessWidget {
  final List<DataBoxChild> dataBoxChildren;
  const DataBoxChildView({Key key, @required this.dataBoxChildren})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    bool addSpace = false;
    for (int i = 0; i < dataBoxChildren.length; !addSpace ? i++ : i + 0) {
      if (addSpace) {
        widgets.add(
          SizedBox(
            height: 8,
          ),
        );
      } else {
        widgets.add(
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  dataBoxChildren[i].iconData,
                  color: dataBoxChildren[i].color,
                ),
              ),
              Container(
                height: 48,
                width: 2,
                decoration: BoxDecoration(
                  color: dataBoxChildren[i].color.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 2),
                      child: Text(
                        dataBoxChildren[i].text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: LitPicTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: -0.1,
                          color: LitPicTheme.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 3),
                          child: Text(
                            dataBoxChildren[i].subtext,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: LitPicTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: LitPicTheme.darkerText,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
      addSpace = !addSpace;
    }
    return Column(children: widgets);
  }
}

class DataBoxView extends StatelessWidget {
  final List<DataBoxChild> dataBoxChildren;
  final AnimationController animationController;
  final Animation animation;

  const DataBoxView(
      {Key key,
      @required this.animationController,
      @required this.animation,
      @required this.dataBoxChildren})
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
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: LitPicTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: LitPicTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4),
                              child: DataBoxChildView(
                                  dataBoxChildren: dataBoxChildren
                                  // [
                                  //   DataBoxChild(
                                  //       text: 'Name',
                                  //       subtext: customer.name,
                                  //       color: Colors.red),
                                  //   DataBoxChild(
                                  //       text: 'Email',
                                  //       subtext: customer.email,
                                  //       color: Colors.cyan),
                                  //   DataBoxChild(
                                  //       text: 'Address',
                                  //       subtext:
                                  //           '5 Patrick Street, Trotwood OH, 45426',
                                  //       color: Colors.amber),
                                  // ],
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 24, right: 24, top: 8, bottom: 8),
                    //   child: Container(
                    //     height: 2,
                    //     decoration: BoxDecoration(
                    //       color: LitPicTheme.background,
                    //       borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 24, right: 24, top: 8, bottom: 16),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: <Widget>[
                    //             Text(
                    //               'Carbs',
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                 fontFamily: LitPicTheme.fontName,
                    //                 fontWeight: FontWeight.w500,
                    //                 fontSize: 16,
                    //                 letterSpacing: -0.2,
                    //                 color: LitPicTheme.darkText,
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 4),
                    //               child: Container(
                    //                 height: 4,
                    //                 width: 70,
                    //                 decoration: BoxDecoration(
                    //                   color:
                    //                       HexColor('#87A0E5').withOpacity(0.2),
                    //                   borderRadius: BorderRadius.all(
                    //                       Radius.circular(4.0)),
                    //                 ),
                    //                 child: Row(
                    //                   children: <Widget>[
                    //                     Container(
                    //                       width: ((70 / 1.2) * animation.value),
                    //                       height: 4,
                    //                       decoration: BoxDecoration(
                    //                         gradient: LinearGradient(colors: [
                    //                           HexColor('#87A0E5'),
                    //                           HexColor('#87A0E5')
                    //                               .withOpacity(0.5),
                    //                         ]),
                    //                         borderRadius: BorderRadius.all(
                    //                             Radius.circular(4.0)),
                    //                       ),
                    //                     )
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 6),
                    //               child: Text(
                    //                 '12g left',
                    //                 textAlign: TextAlign.center,
                    //                 style: TextStyle(
                    //                   fontFamily: LitPicTheme.fontName,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 12,
                    //                   color: LitPicTheme.grey.withOpacity(0.5),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: <Widget>[
                    //             Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 Text(
                    //                   'Protein',
                    //                   textAlign: TextAlign.center,
                    //                   style: TextStyle(
                    //                     fontFamily: LitPicTheme.fontName,
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize: 16,
                    //                     letterSpacing: -0.2,
                    //                     color: LitPicTheme.darkText,
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 4),
                    //                   child: Container(
                    //                     height: 4,
                    //                     width: 70,
                    //                     decoration: BoxDecoration(
                    //                       color: HexColor('#F56E98')
                    //                           .withOpacity(0.2),
                    //                       borderRadius: BorderRadius.all(
                    //                           Radius.circular(4.0)),
                    //                     ),
                    //                     child: Row(
                    //                       children: <Widget>[
                    //                         Container(
                    //                           width: ((70 / 2) *
                    //                               animationController.value),
                    //                           height: 4,
                    //                           decoration: BoxDecoration(
                    //                             gradient:
                    //                                 LinearGradient(colors: [
                    //                               HexColor('#F56E98')
                    //                                   .withOpacity(0.1),
                    //                               HexColor('#F56E98'),
                    //                             ]),
                    //                             borderRadius: BorderRadius.all(
                    //                                 Radius.circular(4.0)),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 6),
                    //                   child: Text(
                    //                     '30g left',
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                       fontFamily: LitPicTheme.fontName,
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 12,
                    //                       color:
                    //                           LitPicTheme.grey.withOpacity(0.5),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: <Widget>[
                    //             Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 Text(
                    //                   'Fat',
                    //                   style: TextStyle(
                    //                     fontFamily: LitPicTheme.fontName,
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize: 16,
                    //                     letterSpacing: -0.2,
                    //                     color: LitPicTheme.darkText,
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(
                    //                       right: 0, top: 4),
                    //                   child: Container(
                    //                     height: 4,
                    //                     width: 70,
                    //                     decoration: BoxDecoration(
                    //                       color: HexColor('#F1B440')
                    //                           .withOpacity(0.2),
                    //                       borderRadius: BorderRadius.all(
                    //                           Radius.circular(4.0)),
                    //                     ),
                    //                     child: Row(
                    //                       children: <Widget>[
                    //                         Container(
                    //                           width: ((70 / 2.5) *
                    //                               animationController.value),
                    //                           height: 4,
                    //                           decoration: BoxDecoration(
                    //                             gradient:
                    //                                 LinearGradient(colors: [
                    //                               HexColor('#F1B440')
                    //                                   .withOpacity(0.1),
                    //                               HexColor('#F1B440'),
                    //                             ]),
                    //                             borderRadius: BorderRadius.all(
                    //                                 Radius.circular(4.0)),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: const EdgeInsets.only(top: 6),
                    //                   child: Text(
                    //                     '10g left',
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                       fontFamily: LitPicTheme.fontName,
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 12,
                    //                       color:
                    //                           LitPicTheme.grey.withOpacity(0.5),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
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

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
