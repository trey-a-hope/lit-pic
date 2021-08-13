//TODO: Find better name.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/session_model.dart';

class FirebaseOrderModel {
  final String id;
  final String customerID;
  final String status;
  final String? trackingNumber;
  final String? carrier;
  final Map shipping;
  final String sessionID;
  
  SessionModel? session;

  FirebaseOrderModel({
    required this.id,
    required this.customerID,
    required this.status,
    required this.trackingNumber,
    required this.carrier,
    required this.shipping,
    required this.sessionID,
  });

  factory FirebaseOrderModel.fromDoc({required DocumentSnapshot doc}) {
    dynamic data = (doc.data() as dynamic);
    return FirebaseOrderModel(
      id: data['id'],
      customerID: data['customerID'],
      status: data['status'],
      trackingNumber: data['trackingNumber'],
      carrier: data['carrier'],
      shipping: data['shipping'],
      sessionID: data['sessionID'],
    );
  }
}
