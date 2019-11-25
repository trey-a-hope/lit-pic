import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/models/stripe/coupon.dart';
import 'package:litpic/models/stripe/order.dart';
import 'dart:convert' show json;

import 'package:litpic/models/stripe/sku.dart';

abstract class StripeOrder {
  Future<List<Order>> list(
      {@required String customerID, @required String status});

  Future<String> create(
      {@required String customerID,
      @required String email,
      @required String name,
      @required String line1,
      @required String city,
      @required String state,
      @required String country,
      @required String postalCode,
      @required List<CartItem> cartItems,
      @required Sku sku});

  Future<void> update(
      {@required String orderID,
      @required String status,
      @required String carrier,
      @required String trackingNumber});

  Future<void> pay(
      {@required String orderID,
      @required String source,
      @required String customerID});
}

class StripeOrderImplementation extends StripeOrder {
  StripeOrderImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<List<Order>> list({String customerID, String status}) async {
    Map data = {'apiKey': apiKey, 'customerID': customerID, 'status': status};

    http.Response response = await http.post(
      '${endpoint}StripeListOrders',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        List<Order> orders = List<Order>();
        Map map = json.decode(response.body);
        for (int i = 0; i < map['data'].length; i++) {
          Order order = Order.fromMap(map: map['data'][i]);
          orders.add(order);
        }
        return orders;
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<String> create(
      {String customerID,
      String email,
      String name,
      String line1,
      String city,
      String state,
      String country,
      String postalCode,
      List<CartItem> cartItems,
      Sku sku}) async {
    int totalLithophanes = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalLithophanes += cartItems[i].quantity;
    }

    Map<String, dynamic> data = {
      'apiKey': apiKey,
      'customerID': customerID,
      'email': email,
      'name': name,
      'line1': line1,
      'city': city,
      'state': state,
      'country': country,
      'postal_code': postalCode,
      'itemType': 'sku',
      'itemParent': sku.id,
      'itemQuantity': '$totalLithophanes'
    };

    http.Response response = await http.post(
      '${endpoint}StripeCreateOrder',
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
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> pay({String orderID, String source, String customerID}) async {
    Map data = {
      'apiKey': apiKey,
      'orderID': orderID,
      'source': source,
      'customerID': customerID
    };

    http.Response response = await http.post(
      '${endpoint}StripePayOrder',
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
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> update(
      {String orderID,
      String status,
      String carrier,
      String trackingNumber}) async {
    Map data = {
      'apiKey': apiKey,
      'orderID': orderID,
      'status': status,
      'carrier': carrier,
      'tracking_number': trackingNumber
    };

    http.Response response = await http.post(
      '${endpoint}StripeUpdateOrder',
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
    } catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
