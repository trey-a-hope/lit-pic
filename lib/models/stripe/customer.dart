import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/credit_card.dart';
import 'package:litpic/models/stripe/shipping.dart';

class Customer {
  final String id;
  final String email;
  final String defaultSource;
  final CreditCard card;
  final String name;
  final Shipping shipping;
  final List<CreditCard> sources;

  Customer(
      {@required this.id,
      @required this.defaultSource,
      @required this.card,
      @required this.email,
      @required this.name,
      @required this.shipping,
      @required this.sources});
}

