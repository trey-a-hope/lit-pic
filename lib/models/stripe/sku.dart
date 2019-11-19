import 'package:flutter/material.dart';

class Sku {
  final DateTime created;
  final String id;
  final String product;
  final double price;
  final DateTime updated;

  Sku(
      {@required this.created,
      @required this.id,
      @required this.product,
      @required this.price,
      @required this.updated});

  factory Sku.fromMap({@required Map map}) {
    return map == null
        ? map
        : Sku(
            created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
            id: map['id'],
            product: map['product'],
            price: map['price'] / 100,
            updated: DateTime.fromMillisecondsSinceEpoch(map['updated'] * 1000),
          );
  }
}
