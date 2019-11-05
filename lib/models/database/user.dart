import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/stripe/customer.dart';

class User {

  final String id;
  final String uid;
  final String customerID;
  final String fcmToken;
  final Timestamp timestamp;
  final bool isAdmin;
  final String imgUrl;

  Customer customer; //Not saved to database, used strictly on FE.

  User(
      {
      @required this.id,
      @required this.customerID,
      @required this.imgUrl,
      @required this.fcmToken,
      @required this.timestamp,
      @required this.uid,
      @required this.isAdmin});

  factory User.fromDoc({@required DocumentSnapshot doc}) {
    return User(
        id: doc.data['id'],
        imgUrl: doc.data['imgUrl'],
        fcmToken: doc.data['fcmToken'],
        isAdmin: doc.data['isAdmin'],
        timestamp: doc.data['timestamp'],
        uid: doc.data['uid'],
        customerID: doc.data['customerID']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'fcmToken': fcmToken,
      'isAdmin': isAdmin,
      'timestamp': timestamp,
      'uid': uid,
      'customerID': customerID
    };
  }
}