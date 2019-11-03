import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heart/models/database/user.dart';

abstract class DB {

  //Miscellanious
  Future<void> addPropertyToDocuments(
      {@required String collection,
      @required String property,
      @required dynamic value});

  //Users
  Future<void> createUser({@required User user});
  Future<User> retrieveUser({@required String id});
  Future<List<User>> retrieveUsers({bool isAdmin, int limit});

  Future<void> updateUser(
      {@required String userID, @required Map<String, dynamic> data});
}

class DBImplementation extends DB {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<void> createUser({User user}) async {
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
  Future<User> retrieveUser({String id}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersDB.document(id).get();
      return User.extractDocument(documentSnapshot);
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
  Future<List<User>> retrieveUsers({bool isAdmin, int limit}) async {
    try {
      Query query = _usersDB;

      if (isAdmin != null) {
        query = query.where('isAdmin', isEqualTo: isAdmin);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      List<DocumentSnapshot> docs = (await query.getDocuments()).documents;
      List<User> users = List<User>();
      for (int i = 0; i < docs.length; i++) {
        users.add(
          User.extractDocument(docs[i]),
        );
      }

      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
