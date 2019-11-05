import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/credit_card.dart';

class Customer {
  final String id;
  final String email;
  final String default_source;
  final CreditCard card;
  final bool isSubscribed;
  final String name;

  Customer(
      {@required this.id,
      @required this.default_source,
      @required this.card,
      @required this.isSubscribed,
      @required this.email,
      @required this.name});
}
