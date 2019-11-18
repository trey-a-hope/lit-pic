import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String imgUrl;
  final String imgPath;
  final int quantity;
  final String title;
  final String color;

  CartItem(
      {@required this.id,
      @required this.imgUrl,
      @required this.imgPath,
      @required this.title,
      @required this.quantity,
      @required this.color});

  factory CartItem.fromDoc({@required DocumentSnapshot doc}) {
    return CartItem(
        id: doc.data['id'],
        imgUrl: doc.data['imgUrl'],
        imgPath: doc.data['imgPath'],
        quantity: doc.data['quantity'],
        title: doc.data['title'],
        color: doc.data['color']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'imgPath': imgPath,
      'title': title,
      'color': color,
      'quantity': quantity
    };
  }
}
