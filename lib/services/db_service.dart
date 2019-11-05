import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/models/database/user.dart';

abstract class DBService {
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

  //Cart Item
  Future<void> createCartItem(
      {@required String userID, @required CartItem cartItem});
  Future<List<CartItem>> retrieveCartItems({@required String userID});
  Future<void> updateCartItem(
      {@required String userID,
      @required String cartItemID,
      @required Map<String, dynamic> data});
}

class DBServiceImplementation extends DBService {
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
      return User.fromDoc(doc: documentSnapshot);
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
          User.fromDoc(doc: docs[i]),
        );
      }

      return users;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> createCartItem({String userID, CartItem cartItem}) async {
    try {
      CollectionReference colRef =
          _usersDB.document(userID).collection('Cart Items');

      DocumentReference docRef = await colRef.add(
        cartItem.toMap(),
      );
      await colRef.document(docRef.documentID).updateData(
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
  Future<List<CartItem>> retrieveCartItems({String userID}) async {
    try {
      CollectionReference colRef =
          _usersDB.document(userID).collection('Cart Items');
      List<DocumentSnapshot> docs = (await colRef.getDocuments()).documents;
      List<CartItem> cartItems = List<CartItem>();
      for (int i = 0; i < docs.length; i++) {
        cartItems.add(
          CartItem.fromDoc(doc: docs[i]),
        );
      }
      return cartItems;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateCartItem(
      {String userID, String cartItemID, Map<String, dynamic> data}) async {
    try {
      DocumentReference docRef = _usersDB
          .document(userID)
          .collection('Cart Items')
          .document(cartItemID);
      await docRef.updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
