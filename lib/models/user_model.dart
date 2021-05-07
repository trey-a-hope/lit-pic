import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/customer_model.dart';

class UserModel {
  final String uid;
  final String customerID;
  final String fcmToken;
  final DateTime created;
  final DateTime modified;

  CustomerModel customer; //Only for the FE.

  UserModel({
    @required this.uid,
    @required this.customerID,
    @required this.fcmToken,
    @required this.created,
    @required this.modified,
  });

  factory UserModel.fromDoc({@required DocumentSnapshot doc}) {
    return UserModel(
      uid: doc.data()['uid'],
      customerID: doc.data()['customerID'],
      fcmToken: doc.data()['fcmToken'],
      created: doc.data()['created'].toDate(),
      modified: doc.data()['modified'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'customerID': customerID,
      'fcmToken': fcmToken,
      'created': created,
      'modified': modified,
    };
  }
}
