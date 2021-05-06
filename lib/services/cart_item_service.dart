import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/cart_item_model.dart';

abstract class ICartItemService {
  //Cart Item
  Future<void> createCartItem(
      {@required String userID, @required CartItemModel cartItem});
  Future<List<CartItemModel>> retrieveCartItems({@required String userID});
  Future<void> updateCartItem(
      {@required String userID,
      @required String cartItemID,
      @required Map<String, dynamic> data});
  Future<void> deleteCartItem(
      {@required String userID, @required String cartItemID});
}

class CartItemService extends ICartItemService {
  final CollectionReference _usersDB = Firestore.instance.collection('Users');

  @override
  Future<void> createCartItem({String userID, CartItemModel cartItem}) async {
    try {
      final CollectionReference colRef =
          _usersDB.document(userID).collection('Cart Items');

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
  Future<List<CartItemModel>> retrieveCartItems({String userID}) async {
    try {
      CollectionReference colRef =
          _usersDB.document(userID).collection('Cart Items');
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
}
