import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;

abstract class StripeCard {
  Future<String> create({@required String customerID, @required String token});
  Future<bool> delete({@required String customerID, @required String cardID});
}

class StripeCardImplementation extends StripeCard {
  StripeCardImplementation({@required this.apiKey, @required this.endpoint});

  final String apiKey;
  final String endpoint;

  @override
  Future<String> create(
      {@required String customerID, @required String token}) async {
    Map data = {'apiKey': apiKey, 'customerID': customerID, 'token': token};

    http.Response response = await http.post(
      endpoint + 'StripeCreateCard',
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
  Future<bool> delete(
      {@required String customerID, @required String cardID}) async {
    Map data = {'apiKey': apiKey, 'customerID': customerID, 'cardID': cardID};

    http.Response response = await http.post(
      endpoint + 'StripeDeleteCard',
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      return map['deleted'];
    } catch (e) {
      throw Exception();
    }
  }
}
