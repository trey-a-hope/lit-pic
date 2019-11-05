import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/credit_card.dart';

class Customer {
  final String id;
  final String email;
  final String defaultSource;
  final CreditCard card;
  final bool isSubscribed;
  final String name;

  Customer(
      {@required this.id,
      @required this.defaultSource,
      @required this.card,
      @required this.isSubscribed,
      @required this.email,
      @required this.name});
}
