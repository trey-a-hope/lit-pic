import 'package:flutter/material.dart';

class Charge {
  String id;
  double amount;
  DateTime created;
  String description;

  Charge(
      {@required this.id,
      @required this.amount,
      @required this.created,
      @required this.description});
}
