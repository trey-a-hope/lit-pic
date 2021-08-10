import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/cart_item_model.dart';
import 'package:litpic/models/firebase_order_model.dart';
import 'package:litpic/models/order_model.dart';
import 'package:litpic/models/sku_model.dart';
import 'dart:convert' show json;

import '../constants.dart';

abstract class IOrderService {
  Future<List<OrderModel>> list({String? customerID, String? status});

  Future<FirebaseOrderModel> get({required String orderID});

  Future<String> create({
    required String customerID,
    required String email,
    required String name,
    required String line1,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    required List<CartItemModel> cartItems,
    required SkuModel sku,
  });

  Future<void> update(
      {required String orderID,
      required String status,
      required String carrier,
      required String trackingNumber});

  Future<void> pay(
      {required String orderID,
      required String source,
      required String customerID});
}

class OrderService extends IOrderService {
  final CollectionReference _ordersDB =
      FirebaseFirestore.instance.collection('Orders');

  @override
  Future<List<OrderModel>> list({String? customerID, String? status}) async {
    Map data = {};

    if (customerID != null) {
      data['customerID'] = customerID;
    }

    if (status != null) {
      data['status'] = status;
    }

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeListOrders'),
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
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<String> create({
    required String customerID,
    required String email,
    required String name,
    required String line1,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    required List<CartItemModel> cartItems,
    required SkuModel sku,
  }) async {
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
      Uri.parse('${GCF_ENDPOINT}StripeCreateOrder'),
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
  Future<void> pay({
    required String orderID,
    required String source,
    required String customerID,
  }) async {
    Map data = {'orderID': orderID, 'source': source, 'customerID': customerID};

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripePayOrder'),
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
  Future<void> update({
    required String orderID,
    required String status,
    required String carrier,
    required String trackingNumber,
  }) async {
    Map data = {
      'orderID': orderID,
      'status': status,
      'carrier': carrier,
      'tracking_number': trackingNumber
    };

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeUpdateOrder'),
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
  Future<FirebaseOrderModel> get({required String orderID}) async {
    try {
      DocumentSnapshot<Object?> doc =
          (await _ordersDB.where('id', isEqualTo: orderID).get()).docs.first;
      FirebaseOrderModel firebaseOrderModel =
          FirebaseOrderModel.fromDoc(doc: doc);
      return firebaseOrderModel;
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
