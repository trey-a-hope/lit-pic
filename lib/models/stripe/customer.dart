import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/credit_card.dart';

class Customer {
  String id;
  String email;
  String default_source;
  CreditCard card;
  bool isSubscribed;

  Customer(
      {@required this.id,
      @required this.default_source,
      @required this.card,
      @required this.isSubscribed});
}
