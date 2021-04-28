import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

abstract class IFormatterService {
  String money({@required double amount});
}

class FormatterService extends IFormatterService {
  @override
  String money({double amount}) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);
    return fmf.output.symbolOnLeft;
  }
}
