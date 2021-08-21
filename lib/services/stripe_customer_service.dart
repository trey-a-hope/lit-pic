import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/credit_card_model.dart';
import 'package:litpic/models/customer_model.dart';
import 'package:litpic/models/shipping_model.dart';
import 'dart:convert' show json;
import '../constants.dart';

abstract class IStripeCustomerService {
  Future<String> create({
    required String? email,
    required String name,
    required String description,
  });
  // Future<List<CustomerModel>> list();
  Future<bool> delete({required String customerID});
  Future<bool> delete10();
  Future<CustomerModel> retrieve({required String customerID});
  Future<void> update({
    required String customerID,
    String? city,
    String? country,
    String? line1,
    String? postalCode,
    String? state,
    String? defaultSource,
    String? name,
    String? email,
  });
}

class StripeCustomerService extends IStripeCustomerService {
  @override
  Future<String> create({
    required String? email,
    required String? name,
    required String? description,
  }) async {
    Map data = {};

    if (email != null) {
      data['email'] = email;
    }

    if (name != null) {
      data['name'] = name;
    }

    if (description != null) {
      data['description'] = description;
    }

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeCreateCustomer'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['id'];
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<CustomerModel> retrieve({required String customerID}) async {
    Map data = {'customerID': customerID};

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeRetrieveCustomer'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);

      if (map['statusCode'] == null) {
        Map? shippingMap = map['shipping'];
        Map? sourcesMap = map['sources'];

        //Add default card if one is active.
        CreditCardModel? card;
        if (map['default_source'] != null) {
          Map cardMap = map['sources']['data'][0];
          card = CreditCardModel(
            id: cardMap['id'],
            brand: cardMap['brand'],
            country: cardMap['country'],
            expMonth: cardMap['exp_month'],
            expYear: cardMap['exp_year'],
            last4: cardMap['last4'],
          );
        }

        //Add sources if available.
        List<CreditCardModel> sources = [];
        if (sourcesMap != null) {
          for (int i = 0; i < sourcesMap['data'].length; i++) {
            Map sourceMap = sourcesMap['data'][i];
            CreditCardModel creditCard = CreditCardModel(
              id: sourceMap['id'],
              country: sourceMap['country'],
              expMonth: sourceMap['exp_month'],
              expYear: sourceMap['exp_year'],
              brand: sourceMap['brand'],
              last4: sourceMap['last4'],
            );
            sources.add(creditCard);
          }
        }

        return CustomerModel(
            id: map['id'],
            email: map['email'],
            defaultSource: map['default_source'],
            card: card,
            name: map['name'],
            shipping: shippingMap == null
                ? null
                : ShippingModel.fromMap(map: shippingMap),
            sources: sources);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> update({
    required String customerID,
    String? city,
    String? country,
    String? line1,
    String? postalCode,
    String? state,
    String? defaultSource,
    String? name,
    String? email,
  }) async {
    Map data = {
      'customerID': customerID,
    };

    if (name != null) {
      data['name'] = name;
    }

    if (line1 != null) {
      data['line1'] = line1;
    }

    if (city != null) {
      data['city'] = city;
    }

    if (country != null) {
      data['country'] = country;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (defaultSource != null) {
      data['default_source'] = defaultSource;
    }

    if (postalCode != null) {
      data['postal_code'] = postalCode;
    }

    if (state != null) {
      data['state'] = state;
    }

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeUpdateCustomer'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return;
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<bool> delete({required String customerID}) async {
    Map data = {'customerID': customerID};

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeDeleteCustomer'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    Map map = json.decode(response.body);
    if (map['statusCode'] == null) {
      return map['deleted'];
    } else {
      throw PlatformException(
          message: map['raw']['message'], code: map['raw']['code']);
    }
  }

  @override
  Future<bool> delete10() async {
    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeDelete10'),
      body: {},
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    Map map = json.decode(response.body);
    if (map['statusCode'] == null) {
      return map['deleted'];
    } else {
      throw PlatformException(
          message: map['raw']['message'], code: map['raw']['code']);
    }
  }

  // @override
  // Future<List<CustomerModel>> list() async {
  //   // Map data = {'customerID': customerID};
  //
  //   http.Response response = await http.post(
  //     Uri.parse('${GCF_ENDPOINT}StripeListCustomers'),
  //     body: {},
  //     headers: {'content-type': 'application/x-www-form-urlencoded'},
  //   );
  //
  //   Map map = json.decode(response.body);
  //   if (map['statusCode'] == null) {
  //     return map['deleted'];
  //   } else {
  //     throw PlatformException(
  //         message: map['raw']['message'], code: map['raw']['code']);
  //   }
  // }
}
