import 'package:flutter/material.dart';

class Address {
  final String city;
  final String country;
  final String line1;
  final String postalCode;
  final String state;

  Address(
      {@required this.city,
      @required this.country,
      @required this.line1,
      @required this.postalCode,
      @required this.state});

  factory Address.fromMap({@required Map map}) {
    return map == null
        ? map
        : Address(
            city: map['city'],
            country: map['country'],
            line1: map['line1'],
            postalCode: map['postal_code'],
            state: map['state']);
  }
}
