import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productID;
  final String imgUrl;
  final String title;

  CartItem({
    @required this.productID,
    @required this.id,
    @required this.imgUrl,
    @required this.title,
  });

  factory CartItem.fromDoc({@required DocumentSnapshot doc}) {
    return CartItem(
        id: doc.data['id'],
        imgUrl: doc.data['imgUrl'],
        productID: doc.data['productID'],
        title: doc.data['title']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'imgUrl': imgUrl, 'productID': productID, 'title': title};
  }
}
