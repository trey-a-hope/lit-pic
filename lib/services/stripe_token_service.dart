import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

import '../constants.dart';

abstract class IStripeTokenService extends ChangeNotifier {
  Future<String> create(
      {@required String number,
      @required String expMonth,
      @required String expYear,
      @required String cvc});
}

class StripeTokenService extends IStripeTokenService {
  @override
  Future<String> create(
      {@required String number,
      @required String expMonth,
      @required String expYear,
      @required String cvc}) async {
    Map data = {
      'number': number,
      'exp_month': expMonth,
      'exp_year': expYear,
      'cvc': cvc
    };

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeCreateToken'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['id'];
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
