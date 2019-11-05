import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

abstract class FormatterService {
  String money({@required double amount});
}

class FormatterServiceImplementation extends FormatterService {
  @override
  String money({double amount}) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);
    return fmf.output.symbolOnLeft;
  }
}
