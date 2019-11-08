import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

import 'package:litpic/models/stripe/charge.dart';

abstract class StripeCharge {
  // Future<bool> create(
  //     {@required double amount,
  //     @required String description,
  //     @required String customerID});
  // Future<String> retrieve({@required String chargeID});
  // Future<List<Charge>> listAll({@required String customerID});
}

class StripeChargeImplementation extends StripeCharge {
  StripeChargeImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  // @override
  // Future<bool> create(
  //     {@required double amount,
  //     @required String description,
  //     @required String customerID}) async {
  //   Map data = {
  //     'apiKey': apiKey,
  //     'amount': (amount * 100).toInt().toString(),
  //     'customerID': customerID,
  //     'description': description
  //   };

  //   http.Response response = await http.post(
  //     endpoint + 'StripeCreateCharge',
  //     body: data,
  //     headers: {'content-type': 'application/x-www-form-urlencoded'},
  //   );

  //   try {
  //     Map map = json.decode(response.body);
  //     return map['paid'];
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  // @override
  // Future<String> retrieve({@required String chargeID}) async {
  //   Map data = {
  //     'apiKey': apiKey,
  //     'chargeID': chargeID,
  //   };

  //   http.Response response = await http.post(
  //     endpoint + 'StripeRetrieveCharge',
  //     body: data,
  //     headers: {'content-type': 'application/x-www-form-urlencoded'},
  //   );

  //   try {
  //     Map map = json.decode(response.body);
  //     return map['id'];
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  // @override
  // Future<List<Charge>> listAll({@required String customerID}) async {
  //   Map data = {
  //     'apiKey': apiKey,
  //     'customerID': customerID,
  //   };

  //   http.Response response = await http.post(
  //     endpoint + 'StripeListAllCharges',
  //     body: data,
  //     headers: {'content-type': 'application/x-www-form-urlencoded'},
  //   );

  //   try {
  //     List<Charge> charges = List<Charge>();
  //     Map map = json.decode(response.body);
  //     for (int i = 0; i < map['data'].length; i++) {
  //       Map chargeMap = map['data'][i];
  //       charges.add(
  //         Charge(
  //           id: chargeMap['id'],
  //           description: chargeMap['description'],
  //           created: DateTime.fromMillisecondsSinceEpoch(
  //               chargeMap['created'] * 1000),
  //           amount: chargeMap['amount'] / 100,
  //         ),
  //       );
  //     }
  //     return charges;
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }
}
