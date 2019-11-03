import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User {
  final String email;//delete
  final String username;//delete

  final String id;
  final String uid;
   String customerID;
  final String fcmToken;
  final DateTime time;
  final bool isAdmin;
  final String imgUrl;

  User(
      {@required this.email,
      @required this.id,
      @required this.imgUrl,
      @required this.isAdmin,
      @required this.fcmToken,
      @required this.time,
      @required this.uid,
      @required this.username});

  static User extractDocument(DocumentSnapshot ds) {
    return User(
        email: ds.data['email'],
        id: ds.data['id'],
        imgUrl: ds.data['imgUrl'],
        fcmToken: ds.data['fcmToken'],
        isAdmin: ds.data['isAdmin'],
        time: ds.data['time'].toDate(),
        uid: ds.data['uid'],
        username: ds.data['username']);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'id': id,
      'imgUrl': imgUrl,
      'fcmToken': fcmToken,
      'isAdmin': isAdmin,
      'time': time,
      'uid': uid,
      'username': username
    };
  }
}
