import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/services/validater.dart';

abstract class Formatter {
  String money({@required double amount});
}

class FormatterImplementation extends Formatter {
  @override
  String money({double amount}) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: amount);
    return fmf.output.symbolOnLeft;
  }
}
