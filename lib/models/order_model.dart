import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/session_model.dart';
import 'package:litpic/models/shipping_model.dart';

class OrderModel {
  final String id;
  final String customerID;
  final String status;
  final String? trackingNumber;
  final String? carrier;
  final ShippingModel shipping;
  final String sessionID;
  final DateTime created;
  final DateTime modified;

  SessionModel? session;

  OrderModel({
    required this.id,
    required this.customerID,
    required this.status,
    required this.trackingNumber,
    required this.carrier,
    required this.shipping,
    required this.sessionID,
    required this.created,
    required this.modified,
  });

  factory OrderModel.fromDoc({required DocumentSnapshot doc}) {
    dynamic data = (doc.data() as dynamic);
    return OrderModel(
      id: data['id'],
      customerID: data['customerID'],
      status: data['status'],
      trackingNumber: data['trackingNumber'],
      carrier: data['carrier'],
      shipping: ShippingModel.fromMap(
        map: data['shipping'],
      ),
      sessionID: data['sessionID'],
      created: DateTime.fromMicrosecondsSinceEpoch(data['created'] * 1000),
      modified: DateTime.fromMicrosecondsSinceEpoch(data['modified'] * 1000),
    );
  }
}
