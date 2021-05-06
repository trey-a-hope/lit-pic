import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/coupon_model.dart';
import 'dart:convert' show json;

import '../constants.dart';

abstract class IStripeCouponService {
  Future<CouponModel> retrieve({@required String couponID});
}

class StripeCouponService extends IStripeCouponService {
  @override
  Future<CouponModel> retrieve({String couponID}) async {
    Map data = {'couponID': couponID};

    http.Response response = await http.post(
      '${GCF_ENDPOINT}StripeRetrieveCoupon',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    Map map = json.decode(response.body);
    if (map['statusCode'] == null) {
      return CouponModel.fromMap(map: map);
    } else {
      throw PlatformException(
          message: map['raw']['message'], code: map['raw']['code']);
    }
  }
}
