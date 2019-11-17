import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/stripe/coupon.dart';
import 'dart:convert' show json;

abstract class StripeCoupon {
  Future<Coupon> retrieve({@required String couponID});
}

class StripeCouponImplementation extends StripeCoupon {
  StripeCouponImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<Coupon> retrieve({String couponID}) async {
    Map data = {'apiKey': apiKey, 'couponID': couponID};

    http.Response response = await http.post(
      endpoint + 'StripeRetrieveCoupon',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return Coupon.fromMap(map: map);
    } catch (e) {
      throw Exception();
    }
  }
}
