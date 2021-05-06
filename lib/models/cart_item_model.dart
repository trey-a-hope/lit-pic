import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItemModel {
  final String id;
  final String imgUrl;
  final String imgPath;
  final int quantity;

  CartItemModel(
      {@required this.id,
      @required this.imgUrl,
      @required this.imgPath,
      @required this.quantity});

  factory CartItemModel.fromDoc({@required DocumentSnapshot doc}) {
    return CartItemModel(
        id: doc.data['id'],
        imgUrl: doc.data['imgUrl'],
        imgPath: doc.data['imgPath'],
        quantity: doc.data['quantity']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'imgPath': imgPath,
      'quantity': quantity
    };
  }
}
