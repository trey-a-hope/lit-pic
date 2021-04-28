import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/stripe/coupon.dart';
import 'dart:convert' show json;

import '../../constants.dart';

abstract class IStripeCouponService {
  Future<Coupon> retrieve({@required String couponID});
}

class StripeCouponService extends IStripeCouponService {
  @override
  Future<Coupon> retrieve({String couponID}) async {
    Map data = {'couponID': couponID};

    http.Response response = await http.post(
      '${GCF_ENDPOINT}StripeRetrieveCoupon',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    Map map = json.decode(response.body);
    if (map['statusCode'] == null) {
      return Coupon.fromMap(map: map);
    } else {
      throw PlatformException(
          message: map['raw']['message'], code: map['raw']['code']);
    }
  }
}
