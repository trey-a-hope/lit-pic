import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/stripe/address.dart';
import 'package:litpic/models/stripe/credit_card.dart';
import 'dart:convert' show json;

import 'package:litpic/models/stripe/customer.dart';
import 'package:litpic/models/stripe/shipping.dart';

abstract class StripeCustomer {
  Future<String> create(
      {@required String email,
      @required String description,
      @required String name});
  Future<Customer> retrieve({@required String customerID});
  Future<void> updateDefaultSource(
      {@required String customerID, String defaultSource});
  Future<void> updateAddress(
      {@required String customerID,
      String city,
      String country,
      String line1,
      String postalCode,
      String state});
  Future<void> updateName({@required String customerID, String name});
  Future<void> updateEmail({@required String customerID, String email});
  Future<void> delete({@required String customerID});
}

class StripeCustomerImplementation extends StripeCustomer {
  StripeCustomerImplementation(
      {@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<String> create(
      {@required String email,
      @required String description,
      @required String name}) async {
    Map data = {
      'apiKey': apiKey,
      'email': email,
      'description': description,
      'name': name
    };

    http.Response response = await http.post(
      endpoint + 'StripeCreateCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return map['id'];
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Customer> retrieve({@required String customerID}) async {
    Map data = {'apiKey': apiKey, 'customerID': customerID};

    http.Response response = await http.post(
      endpoint + 'StripeRetrieveCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map customerMap = json.decode(response.body);
      Map addressMap = customerMap['address'];
      Map sourcesMap = customerMap['sources'];

      //Add default card if one is active.
      CreditCard card;
      if (customerMap['default_source'] != null) {
        Map cardMap = customerMap['sources']['data'][0];
        card = CreditCard(
          id: cardMap['id'],
          brand: cardMap['brand'],
          country: cardMap['country'],
          expMonth: cardMap['exp_month'],
          expYear: cardMap['exp_year'],
          last4: cardMap['last4'],
        );
      }

      //Add sources if available.
      List<CreditCard> sources = List<CreditCard>();
      if (sourcesMap != null) {
        for (int i = 0; i < sourcesMap['data'].length; i++) {
          Map sourceMap = sourcesMap['data'][i];
          CreditCard creditCard = CreditCard(
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

      return Customer(
          id: customerMap['id'],
          email: customerMap['email'],
          defaultSource: customerMap['default_source'],
          card: card,
          name: customerMap['name'],
          shipping: Shipping(
            name: customerMap['name'],
            address: Address.fromMap(map: addressMap),
          ),
          sources: sources);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> updateAddress(
      {String customerID,
      String city,
      String country,
      String line1,
      String postalCode,
      String state}) async {
    Map data = {
      'apiKey': apiKey,
      'customerID': customerID,
      'city': city,
      'country': country,
      'line1': line1,
      'postal_code': postalCode,
      'state': state
    };

    http.Response response = await http.post(
      endpoint + 'StripeUpdateCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> delete({String customerID}) async {
    Map data = {'apiKey': apiKey, 'customerID': customerID};

    http.Response response = await http.post(
      endpoint + 'StripeDeleteCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateEmail({String customerID, String email}) async {
    Map data = {'apiKey': apiKey, 'customerID': customerID, 'email': email};

    http.Response response = await http.post(
      endpoint + 'StripeUpdateCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> updateName({String customerID, String name}) async {
    Map data = {
      'apiKey': apiKey,
      'customerID': customerID,
      'name': name,
    };

    http.Response response = await http.post(
      endpoint + 'StripeUpdateCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> updateDefaultSource(
      {String customerID, String defaultSource}) async {
    Map data = {
      'apiKey': apiKey,
      'customerID': customerID,
      'default_source': defaultSource,
    };

    http.Response response = await http.post(
      endpoint + 'StripeUpdateCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return;
    } catch (e) {
      throw Exception();
    }
  }
}
