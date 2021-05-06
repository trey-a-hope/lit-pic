import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/cart_item_model.dart';
import 'package:litpic/models/order_model.dart';
import 'package:litpic/models/sku_model.dart';
import 'dart:convert' show json;

import '../constants.dart';

abstract class IStripeOrderService {
  Future<List<OrderModel>> list({String customerID, @required String status});

  Future<String> create(
      {@required String customerID,
      @required String email,
      @required String name,
      @required String line1,
      @required String city,
      @required String state,
      @required String country,
      @required String postalCode,
      @required List<CartItemModel> cartItems,
      @required SkuModel sku});

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

class StripeOrderService extends IStripeOrderService {
  @override
  Future<List<OrderModel>> list({String customerID, String status}) async {
    Map data = {};

    if (customerID != null) {
      data['customerID'] = customerID;
    }

    if (status != null) {
      data['status'] = status;
    }

    http.Response response = await http.post(
      '${GCF_ENDPOINT}StripeListOrders',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        List<OrderModel> orders = [];
        Map map = json.decode(response.body);
        for (int i = 0; i < map['data'].length; i++) {
          OrderModel order = OrderModel.fromMap(map: map['data'][i]);
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
      List<CartItemModel> cartItems,
      SkuModel sku}) async {
    int totalLithophanes = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalLithophanes += cartItems[i].quantity;
    }

    Map<String, dynamic> data = {
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
      '${GCF_ENDPOINT}StripeCreateOrder',
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
    Map data = {'orderID': orderID, 'source': source, 'customerID': customerID};

    http.Response response = await http.post(
      '${GCF_ENDPOINT}StripePayOrder',
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
      'orderID': orderID,
      'status': status,
      'carrier': carrier,
      'tracking_number': trackingNumber
    };

    http.Response response = await http.post(
      '${GCF_ENDPOINT}StripeUpdateOrder',
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
