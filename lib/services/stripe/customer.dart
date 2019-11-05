import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/stripe/credit_card.dart';
import 'dart:convert' show json;

import 'package:litpic/models/stripe/customer.dart';

abstract class StripeCustomer {
  Future<String> create({@required String email,
      @required String description,
      @required String name});
  Future<Customer> retrieve({@required String customerID});
  Future<void> update({@required String customerID, @required String token});
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
    Map data = {'apiKey': apiKey, 'customerId': customerID};

    http.Response response = await http.post(
      endpoint + 'StripeRetrieveCustomer',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map customerMap = json.decode(response.body);

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

      return Customer(
          id: customerMap['id'],
          email: customerMap['email'],
          defaultSource: customerMap['default_source'],
          card: card,
          name: customerMap['name'],
          isSubscribed: customerMap['subscriptions'] != null);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> update(
      {@required String customerID, @required String token}) async {
    Map data = {'apiKey': apiKey, 'customerId': customerID, 'token': token};

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
