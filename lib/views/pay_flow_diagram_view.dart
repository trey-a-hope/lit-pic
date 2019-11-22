import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PayFlowDiagramView extends StatelessWidget {
  final bool shippingComplete;
  final bool paymentComplete;
  final bool submitComplete;
  final AnimationController animationController;
  final Animation animation;
  PayFlowDiagramView({
    Key key,
    @required this.shippingComplete,
    @required this.paymentComplete,
    @required this.submitComplete,
    @required this.animationController,
    @required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    MdiIcons.mailbox,
                    size: 40,
                    color: shippingComplete ? Colors.green : Colors.grey,
                  ),
                  Icon(
                    MdiIcons.creditCard,
                    size: 40,
                    color: paymentComplete ? Colors.green : Colors.grey,
                  ),
                  Icon(
                    MdiIcons.check,
                    size: 40,
                    color: submitComplete ? Colors.green : Colors.grey,
                  )
                ],
              ),
          ),
        );
      },
    );
  }
}
