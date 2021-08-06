import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/price_model.dart';
import 'dart:convert' show json;
import '../constants.dart';

abstract class IStripePriceService {
  Future<PriceModel> get({required String priceID});
}

class StripePriceService extends IStripePriceService {
  @override
  Future<PriceModel> get({required String priceID}) async {
    Map data = {'priceID': priceID};

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeRetrievePrice'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return PriceModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
