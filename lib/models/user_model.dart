import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/customer_model.dart';

class UserModel {
  final String id; //delete
  final String uid;
  final String customerID;
  final String fcmToken;
  final Timestamp timestamp; //call created, make DateTime.
  //add modified, make DateTime.
  final bool isAdmin; //delete

  CustomerModel customer; //Not saved to database, used strictly on FE.

  UserModel(
      {@required this.id,
      @required this.customerID,
      @required this.fcmToken,
      @required this.timestamp,
      @required this.uid,
      @required this.isAdmin});

  factory UserModel.fromDoc({@required DocumentSnapshot doc}) {
    return UserModel(
        id: doc.data['id'],
        fcmToken: doc.data['fcmToken'],
        isAdmin: doc.data['isAdmin'],
        timestamp: doc.data['timestamp'],
        uid: doc.data['uid'],
        customerID: doc.data['customerID']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fcmToken': fcmToken,
      'isAdmin': isAdmin,
      'timestamp': timestamp,
      'uid': uid,
      'customerID': customerID
    };
  }
}
