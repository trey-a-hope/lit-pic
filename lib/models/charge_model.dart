import 'package:flutter/material.dart';

class ChargeModel {
  String id;
  double amount;
  DateTime created;
  String description;

  ChargeModel(
      {@required this.id,
      @required this.amount,
      @required this.created,
      @required this.description});
}
