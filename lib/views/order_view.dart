import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/models/stripe/order.dart';
import 'package:litpic/services/formatter_service.dart';

class OrderView extends StatelessWidget {
  final Order order;
  final AnimationController animationController;
  final Animation animation;
  final VoidCallback onTap;
  final GetIt getIt = GetIt.I;

  OrderView(
      {Key key,
      @required this.order,
      @required this.animationController,
      @required this.animation,
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
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Card(
                child: ListTile(
                  onTap: onTap,
                  title: Text(
                      getIt<FormatterService>().money(amount: order.amount)),
                  subtitle: Text('ID : ${order.id}'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}