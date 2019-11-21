import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/stripe/coupon.dart';
import 'package:litpic/models/stripe/order.dart';
import 'dart:convert' show json;

import 'package:litpic/models/stripe/sku.dart';

abstract class StripeOrder {
  Future<List<Order>> list({@required String customerID, @required String status});
}

class StripeOrderImplementation extends StripeOrder {
  StripeOrderImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<List<Order>> list({String customerID, String status}) async {
    Map data = {'apiKey': apiKey, 'customerID': customerID, 'status': status};

    http.Response response = await http.post(
      endpoint + 'StripeListOrders',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      List<Order> orders = List<Order>();
      Map map = json.decode(response.body);
      for(int i = 0; i < map['data'].length; i++){
        Order order = Order.fromMap(map: map['data'][i]);
        orders.add(order);
      }
      return orders;
    } catch (e) {
      throw Exception();
    }
  }
}
