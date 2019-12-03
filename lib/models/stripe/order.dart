import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/address.dart';
import 'package:litpic/models/stripe/shipping.dart';

class Order {
  final DateTime created;
  final String id;
  final double amount;
  final DateTime updated;
  final String description;
  final int quantity;
  final String carrier;
  final String trackingNumber;
  final Shipping shipping;
  final String customerID;

  Order(
      {@required this.created,
      @required this.id,
      @required this.amount,
      @required this.updated,
      @required this.description,
      @required this.quantity,
      @required this.carrier,
      @required this.trackingNumber,
      @required this.shipping,
      @required this.customerID});

  factory Order.fromMap({@required Map map}) {
    return map == null
        ? map
        : Order(
            shipping: Shipping(
                name: map['shipping']['name'],
                address: Address.fromMap(map: map['shipping']['address'])),
            description: map['items'][0]['description'],
            quantity: map['items'][0]['quantity'],
            created: DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000),
            id: map['id'],
            amount: map['amount'] / 100,
            updated: DateTime.fromMillisecondsSinceEpoch(map['updated'] * 1000),
            carrier: map['shipping']['carrier'],
            trackingNumber: map['shipping']['tracking_number'],
            customerID: map['customer']);
  }
}
