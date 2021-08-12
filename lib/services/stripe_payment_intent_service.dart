import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/payment_intent_model.dart';
import 'dart:convert' show json;
import '../constants.dart';

abstract class IStripePaymentIntentService {
  Future<PaymentIntentModel> retrieve({required String paymentIntentID});
}

class StripePaymentIntentService extends IStripePaymentIntentService {
  @override
  Future<PaymentIntentModel> retrieve({required String paymentIntentID}) async {
    Map data = {'paymentIntentID': paymentIntentID};

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripePaymentIntentRetrieve'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return PaymentIntentModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
