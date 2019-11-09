
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class StripeToken extends ChangeNotifier {
  Future<String> create(
      {@required String number,
      @required String expMonth,
      @required String expYear,
      @required String cvc});
}

class StripeTokenImplementation extends StripeToken {
  StripeTokenImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<String> create(
      {@required String number,
      @required String expMonth,
      @required String expYear,
      @required String cvc}) async {
    Map data = {
      'apiKey': apiKey,
      'number': number,
      'exp_month': expMonth,
      'exp_year': expYear,
      'cvc': cvc
    };

    http.Response response = await http.post(
      endpoint + 'StripeCreateToken',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return map['id'];
    } catch (e) {
      throw Exception();
    }
  }
}
