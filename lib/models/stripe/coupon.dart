import 'package:flutter/material.dart';

class Coupon {
  final int amountOff;
  final DateTime created;
  final String id;
  final int percentOff;
  final String name;

  Coupon(
      {@required this.amountOff,
      @required this.created,
      @required this.id,
      @required this.percentOff,
      @required this.name});

  factory Coupon.fromMap({@required Map map}) {
    return map == null
        ? map
        : Coupon(
            amountOff: map['amount_off'],
            created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
            id: map['id'],
            percentOff: map['percent_off'],
            name: map['name']);
  }
}
