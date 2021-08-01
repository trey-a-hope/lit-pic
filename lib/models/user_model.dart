import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/customer_model.dart';

class UserModel {
  final String uid;
  final String customerID;
  final String? fcmToken;
  final DateTime created;
  final DateTime modified;

  CustomerModel? customer; //Only for the FE.

  UserModel({
    required this.uid,
    required this.customerID,
    required this.fcmToken,
    required this.created,
    required this.modified,
  });

  factory UserModel.fromDoc({required DocumentSnapshot doc}) {
    return UserModel(
      uid: (doc.data() as dynamic)['uid'],
      customerID: (doc.data() as dynamic)['customerID'],
      fcmToken: (doc.data() as dynamic)['fcmToken'],
      created: (doc.data() as dynamic)['created'].toDate(),
      modified: (doc.data() as dynamic)['modified'].toDate(),
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
