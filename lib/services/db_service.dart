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
  Future<void> deleteUser({@required String id});
  Future<User> retrieveUser({String id, String customerID});
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
  Future<void> deleteCartItem(
      {@required String userID, @required String cartItemID});

  //Sku
  Future<String> retrieveSkuID();

  //Admin
  Future<String> retrieveAdminDocID();
}

class DBServiceImplementation extends DBService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');
  final DocumentReference _dataDB =
      Firestore.instance.collection('Data').document('OCqQBQf9d5GM2sbSrF85');

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
  Future<User> retrieveUser({String id, String customerID}) async {
    try {
      if (id != null) {
        DocumentSnapshot documentSnapshot = await _usersDB.document(id).get();
        return User.fromDoc(doc: documentSnapshot);
      } else if (customerID != null) {
        DocumentSnapshot documentSnapshot = (await _usersDB
                .where('customerID', isEqualTo: customerID)
                .getDocuments())
            .documents
            .first;
        return User.fromDoc(doc: documentSnapshot);
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
      CollectionReference colRef =
          _usersDB.document(userID).collection('Cart Items');
      DocumentReference docRef = colRef.document(cartItemID);
      await docRef.updateData(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteCartItem({String userID, String cartItemID}) async {
    try {
      //Delete cart item from database.
      CollectionReference colRef =
          _usersDB.document(userID).collection('Cart Items');
      await colRef.document(cartItemID).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
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
  Future<String> retrieveSkuID() async {
    return (await _dataDB.get()).data['skuID'];
  }

  @override
  Future<String> retrieveAdminDocID() async {
    return (await _dataDB.get()).data['adminDocID'];
  }
}
