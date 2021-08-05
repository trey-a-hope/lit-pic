import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/cart_item_model.dart';
import 'package:litpic/models/firebase_order_model.dart';
import 'package:litpic/models/order_model.dart';
import 'package:litpic/models/product_model.dart';
import 'package:litpic/models/sku_model.dart';
import 'dart:convert' show json;

import '../constants.dart';

abstract class IStripeProductService {
  Future<ProductModel> get({required String prodID});
}

class StripeProductService extends IStripeProductService {
  @override
  Future<ProductModel> get({required String prodID}) async {
    Map data = {'prodID': prodID};

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeRetrieveProduct'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return ProductModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
