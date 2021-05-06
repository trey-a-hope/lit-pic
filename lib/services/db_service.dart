import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/litpic_model.dart';
import 'package:litpic/models/user_model.dart';

abstract class IDBService {
  //Lit Pic
  Future<List<LitPicModel>> retrieveLitPics();

  //Miscellanious
  Future<void> addPropertyToDocuments(
      {@required String collection,
      @required String property,
      @required dynamic value});

  //Users
  Future<void> createUser({@required UserModel user});
  Future<void> deleteUser({@required String id});
  Future<UserModel> retrieveUser({String id, String customerID});
  Future<List<UserModel>> retrieveUsers({bool isAdmin, int limit});
  Future<void> updateUser(
      {@required String userID, @required Map<String, dynamic> data});
}

class DBService extends IDBService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  final DocumentReference _dataDB =
      Firestore.instance.collection('Data').document('OCqQBQf9d5GM2sbSrF85');
  final CollectionReference _litPicsDB =
      Firestore.instance.collection('Lit Pics');

  @override
  Future<void> createUser({UserModel user}) async {
    try {
      DocumentReference docRef = await _usersDB.add(
        user.toMap(),
      );
      await _usersDB.document(docRef.documentID).updateData(
        {'id': docRef.documentID},
      );
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel> retrieveUser({String id, String customerID}) async {
    try {
      if (id != null) {
        DocumentSnapshot documentSnapshot = await _usersDB.document(id).get();
        return UserModel.fromDoc(doc: documentSnapshot);
      } else if (customerID != null) {
        DocumentSnapshot documentSnapshot = (await _usersDB
                .where('customerID', isEqualTo: customerID)
                .getDocuments())
            .documents
            .first;
        return UserModel.fromDoc(doc: documentSnapshot);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addPropertyToDocuments(
      {String collection, String property, dynamic value}) async {
    try {
      final CollectionReference colRef =
          Firestore.instance.collection(collection);
      QuerySnapshot querySnapshot = await colRef.getDocuments();
      List<DocumentSnapshot> docs = querySnapshot.documents;
      for (int i = 0; i < docs.length; i++) {
        await colRef.document(docs[i].documentID).updateData(
          {property: value},
        );
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> updateUser({String userID, Map<String, dynamic> data}) async {
    try {
      await _usersDB.document(userID).updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<UserModel>> retrieveUsers({bool isAdmin, int limit}) async {
    try {
      Query query = _usersDB;

      if (isAdmin != null) {
        query = query.where('isAdmin', isEqualTo: isAdmin);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      List<DocumentSnapshot> docs = (await query.getDocuments()).documents;
      List<UserModel> users = [];
      for (int i = 0; i < docs.length; i++) {
        users.add(
          UserModel.fromDoc(doc: docs[i]),
        );
      }

      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteUser({String id}) async {
    try {
      await _usersDB.document(id).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<LitPicModel>> retrieveLitPics() async {
    try {
      List<DocumentSnapshot> docs = (await _litPicsDB.getDocuments()).documents;
      List<LitPicModel> litPics = [];
      for (int i = 0; i < docs.length; i++) {
        litPics.add(
          LitPicModel.fromDoc(doc: docs[i]),
        );
      }

      return litPics;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
