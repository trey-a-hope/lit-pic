import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/user_model.dart';

abstract class IUserService {
  Future<void> createUser({@required UserModel user});
  Future<UserModel> retrieveUser({@required String uid});
  Future<UserModel> retrieveUserByCustomerID({@required String customerID});
  Future<void> updateUser(
      {@required String uid, @required Map<String, dynamic> data});
  Future<void> deleteUser({@required String uid});
  // Future<List<UserModel>> retrieveUsers({bool isAdmin, int limit});
}

class UserService extends IUserService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<void> createUser({@required UserModel user}) async {
    try {
      DocumentReference docRef = _usersDB.document(user.uid);

      docRef.setData(user.toMap());

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel> retrieveUser({@required String uid}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersDB.document(uid).get();
      return UserModel.fromDoc(doc: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> retrieveUserByCustomerID(
      {@required String customerID}) async {
    try {
      DocumentSnapshot documentSnapshot = (await _usersDB
              .where('customerID', isEqualTo: customerID)
              .getDocuments())
          .documents
          .first;
      return UserModel.fromDoc(doc: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateUser(
      {@required String uid, @required Map<String, dynamic> data}) async {
    try {
      await _usersDB.document(uid).updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  // @override
  // Future<List<UserModel>> retrieveUsers({bool isAdmin, int limit}) async {
  //   try {
  //     Query query = _usersDB;

  //     if (isAdmin != null) {
  //       query = query.where('isAdmin', isEqualTo: isAdmin);
  //     }

  //     if (limit != null) {
  //       query = query.limit(limit);
  //     }

  //     List<DocumentSnapshot> docs = (await query.getDocuments()).documents;
  //     List<UserModel> users = [];
  //     for (int i = 0; i < docs.length; i++) {
  //       users.add(
  //         UserModel.fromDoc(doc: docs[i]),
  //       );
  //     }

  //     return users;
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  @override
  Future<void> deleteUser({String uid}) async {
    try {
      await _usersDB.document(uid).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
