import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/address.dart';

class Shipping {
  final String name;
  final Address address;

  Shipping({@required this.name, @required this.address});

  factory Shipping.fromMap({@required Map map}) {
    return map == null
        ? map
        : Shipping(name: map['name'], address: Address.fromMap(map: map['address']));
  }
}
