import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productID;
  final String imgUrl;
  final int quantity;
  final String title;

  CartItem(
      {@required this.productID,
      @required this.id,
      @required this.imgUrl,
      @required this.title,
      @required this.quantity});

  factory CartItem.fromDoc({@required DocumentSnapshot doc}) {
    return CartItem(
        id: doc.data['id'],
        imgUrl: doc.data['imgUrl'],
        productID: doc.data['productID'],
        quantity: doc.data['quantity'],
        title: doc.data['title']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'productID': productID,
      'title': title,
      'quantity': quantity
    };
  }
}
