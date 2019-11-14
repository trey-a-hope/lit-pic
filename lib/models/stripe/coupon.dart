import 'package:flutter/material.dart';

class Coupon {
  final int amountOff;
  final DateTime created;
  final String id;
  final double percentOff;

  Coupon(
      {@required this.amountOff,
      @required this.created,
      @required this.id,
      @required this.percentOff});

  factory Coupon.fromMap({@required Map map}) {
    return map == null
        ? map
        : Coupon(
            amountOff: map['amount_off'],
            created: map['created'],
            id: map['id'],
            percentOff: map['percent_off']);
  }
}
