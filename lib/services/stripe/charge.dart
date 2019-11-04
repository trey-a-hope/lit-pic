import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

import 'package:litpic/models/stripe/charge.dart';

abstract class StripeCharge {
  Future<bool> create(
      {@required double amount,
      @required String description,
      @required String customerId});
  Future<String> retrieve({@required String chargeId});
  Future<List<Charge>> listAll({@required String customerId});
}

class StripeChargeImplementation extends StripeCharge {
  StripeChargeImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<bool> create(
      {@required double amount,
      @required String description,
      @required String customerId}) async {
    Map data = {
      'apiKey': apiKey,
      'amount': (amount * 100).toInt().toString(),
      'customerId': customerId,
      'description': description
    };

    http.Response response = await http.post(
      endpoint + 'StripeCreateCharge',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return map['paid'];
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<String> retrieve({@required String chargeId}) async {
    Map data = {
      'apiKey': apiKey,
      'chargeId': chargeId,
    };

    http.Response response = await http.post(
      endpoint + 'StripeRetrieveCharge',
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

  @override
  Future<List<Charge>> listAll({@required String customerId}) async {
    Map data = {
      'apiKey': apiKey,
      'customerId': customerId,
    };

    http.Response response = await http.post(
      endpoint + 'StripeListAllCharges',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      List<Charge> charges = List<Charge>();
      Map map = json.decode(response.body);
      for (int i = 0; i < map['data'].length; i++) {
        Map chargeMap = map['data'][i];
        charges.add(
          Charge(
            id: chargeMap['id'],
            description: chargeMap['description'],
            created: DateTime.fromMillisecondsSinceEpoch(
                chargeMap['created'] * 1000),
            amount: chargeMap['amount'] / 100,
          ),
        );
      }
      return charges;
    } catch (e) {
      throw Exception();
    }
  }
}
