import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/credit_card.dart';

class Customer {
  final String id;
  final String email;
  final String defaultSource;
  final CreditCard card;
  final String name;
  final Address address;
  final List<CreditCard> sources;

  Customer(
      {@required this.id,
      @required this.defaultSource,
      @required this.card,
      @required this.email,
      @required this.name,
      @required this.address,
      @required this.sources});
}

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
