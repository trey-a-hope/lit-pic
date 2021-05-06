import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/cart_item_model.dart';

abstract class ICartItemService {
  //Cart Item
  Future<void> createCartItem(
      {@required String uid, @required CartItemModel cartItem});
  Future<List<CartItemModel>> retrieveCartItems({@required String uid});
  Future<void> updateCartItem(
      {@required String uid,
      @required String cartItemID,
      @required Map<String, dynamic> data});
  Future<void> deleteCartItem(
      {@required String uid, @required String cartItemID});
}

class CartItemService extends ICartItemService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<void> createCartItem(
      {@required String uid, @required CartItemModel cartItem}) async {
    try {
      final CollectionReference colRef =
          _usersDB.document(uid).collection('cartItems');

      final DocumentReference docRef = colRef.document();

      cartItem.id = docRef.documentID;

      await docRef.setData(
        cartItem.toMap(),
      );

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<List<CartItemModel>> retrieveCartItems({@required String uid}) async {
    try {
      CollectionReference colRef =
          _usersDB.document(uid).collection('cartItems');
      List<DocumentSnapshot> docs = (await colRef.getDocuments()).documents;
      List<CartItemModel> cartItems = [];
      for (int i = 0; i < docs.length; i++) {
        cartItems.add(
          CartItemModel.fromDoc(doc: docs[i]),
        );
      }
      return cartItems;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateCartItem(
      {@required String uid,
      @required String cartItemID,
      @required Map<String, dynamic> data}) async {
    try {
      CollectionReference colRef =
          _usersDB.document(uid).collection('cartItems');
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
  Future<void> deleteCartItem(
      {@required String uid, @required String cartItemID}) async {
    try {
      //Delete cart item from database.
      CollectionReference colRef =
          _usersDB.document(uid).collection('cartItems');
      await colRef.document(cartItemID).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
