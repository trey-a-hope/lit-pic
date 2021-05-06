import 'package:flutter/material.dart';
import 'package:litpic/models/shipping_model.dart';
import 'address_model.dart';

class OrderModel {
  final DateTime created;
  final String id;
  final double amount;
  final DateTime updated;
  final String description;
  final int quantity;
  final String carrier;
  final String trackingNumber;
  final ShippingModel shipping;
  final String customerID;

  OrderModel(
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

  factory OrderModel.fromMap({@required Map map}) {
    return map == null
        ? map
        : OrderModel(
            shipping: ShippingModel(
                name: map['shipping']['name'],
                address: AddressModel.fromMap(map: map['shipping']['address'])),
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
