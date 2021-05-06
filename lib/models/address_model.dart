import 'package:flutter/material.dart';

class AddressModel {
  final String city;
  final String country;
  final String line1;
  final String postalCode;
  final String state;

  AddressModel(
      {@required this.city,
      @required this.country,
      @required this.line1,
      @required this.postalCode,
      @required this.state});

  factory AddressModel.fromMap({@required Map map}) {
    return map == null
        ? map
        : AddressModel(
            city: map['city'],
            country: map['country'],
            line1: map['line1'],
            postalCode: map['postal_code'],
            state: map['state']);
  }
}
