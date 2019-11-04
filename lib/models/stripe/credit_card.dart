import 'package:flutter/material.dart';

class CreditCard {
  String id;
  String brand;
  String country;
  int exp_month;
  int exp_year;
  String last4;

  CreditCard(
      {@required this.id,
      @required this.brand,
      @required this.country,
      @required this.exp_month,
      @required this.exp_year,
      @required this.last4});
}
