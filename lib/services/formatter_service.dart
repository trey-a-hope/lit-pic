import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

abstract class IFormatterService {
  String money({@required double amount});
}

class FormatterService extends IFormatterService {
  @override
  String money({@required double amount}) {
    Currency usdCurrency = Currency.create('USD', 2);
    Money sellPrice = Money.from(amount, usdCurrency);
    return sellPrice.toString();
  }
}
