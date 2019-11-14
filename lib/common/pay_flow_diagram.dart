import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PayFlowDiagram extends StatelessWidget {
  final bool shippingComplete;
  final bool paymentComplete;
  final bool submitComplete;
  PayFlowDiagram(
      {Key key,
      @required this.shippingComplete,
      @required this.paymentComplete,
      @required this.submitComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
