import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String email; //delete
  final String username; //delete

  final String id;
  final String uid;
  String customerID;
  final String fcmToken;
  final Timestamp timestamp;
  final bool isAdmin;
  final String imgUrl;

  User(
      {@required this.email,
      @required this.id,
      @required this.imgUrl,
      @required this.isAdmin,
      @required this.fcmToken,
      @required this.timestamp,
      @required this.uid,
      @required this.username});

  factory User.fromDoc({@required DocumentSnapshot doc}) {
    return User(
        email: doc.data['email'],
        id: doc.data['id'],
        imgUrl: doc.data['imgUrl'],
        fcmToken: doc.data['fcmToken'],
        isAdmin: doc.data['isAdmin'],
        timestamp: doc.data['time'],
        uid: doc.data['uid'],
        username: doc.data['username']);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'imgUrl': imgUrl,
      'fcmToken': fcmToken,
      'isAdmin': isAdmin,
      'time': timestamp,
      'uid': uid,
      'username': username
    };
  }
}
