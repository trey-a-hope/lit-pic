import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:litpic/models/sku_model.dart';

import '../constants.dart';

abstract class IStripeSkuService {
  Future<SkuModel> retrieve({@required String skuID});
}

class StripeSkuService extends IStripeSkuService {
  @override
  Future<SkuModel> retrieve({String skuID}) async {
    Map data = {'skuID': skuID};

    http.Response response = await http.post(
      '${GCF_ENDPOINT}StripeRetrieveSku',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return SkuModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
