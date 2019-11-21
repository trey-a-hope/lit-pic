import 'package:flutter/material.dart';

class Order {
  final DateTime created;
  final String id;
  final double amount;
  final DateTime updated;

  Order(
      {@required this.created,
      @required this.id,
      @required this.amount,
      @required this.updated});

  factory Order.fromMap({@required Map map}) {
    return map == null
        ? map
        : Order(
            created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
            id: map['id'],
            amount: map['amount'] / 100,
            updated:
                DateTime.fromMillisecondsSinceEpoch(map['updated'] * 1000));
  }
}
