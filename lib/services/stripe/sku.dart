import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/stripe/coupon.dart';
import 'dart:convert' show json;

import 'package:litpic/models/stripe/sku.dart';

abstract class StripeSku {
  Future<Sku> retrieve({@required String skuID});
}

class StripeSkuImplementation extends StripeSku {
  StripeSkuImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<Sku> retrieve({String skuID}) async {
    Map data = {'apiKey': apiKey, 'skuID': skuID};

    http.Response response = await http.post(
      endpoint + 'StripeRetrieveSku',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return Sku.fromMap(map: map);
    } catch (e) {
      throw Exception();
    }
  }
}
