import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:litpic/models/session_model.dart';
import 'dart:convert' show json;
import '../constants.dart';

abstract class IStripeSessionService {
  Future<String> create({required SessionModel session});
  Future<SessionModel> retrieve({required String sessionID});
  Future<List<SessionModel>> list({required int limit});
}

class StripeSessionService extends IStripeSessionService {
  //https://stripe.com/docs/api/checkout/sessions/create
  @override
  Future<String> create({required SessionModel session}) async {
    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeCreateSession'),
      body: session.toMap(),
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['id'];
      } else {
        throw PlatformException(
          message: map['raw']['message'],
          code: map['raw']['statusCode'].toString(),
        );
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<SessionModel> retrieve({required String sessionID}) async {
    Map data = {'sessionID': sessionID};

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeRetrieveSession'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return SessionModel.fromMap(map: map);
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<List<SessionModel>> list({required int limit}) async {
    Map<String, dynamic> data = {
      'limit': '$limit',
    };

    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}StripeListSessions'),
      body: data,
      headers: {'content-type': 'application/x-www-form-urlencoded'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        List data = map['data'] as List;
        List<SessionModel> sessions =
            data.map((d) => SessionModel.fromMap(map: d)).toList();

        return sessions;
      } else {
        throw PlatformException(
            message: map['raw']['message'], code: map['raw']['code']);
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
