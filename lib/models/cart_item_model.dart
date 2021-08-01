import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  String? id;
  String imgUrl;
  String imgPath;
  int quantity;

  CartItemModel(
      {required this.id,
      required this.imgUrl,
      required this.imgPath,
      required this.quantity});

  factory CartItemModel.fromDoc({required DocumentSnapshot doc}) {
    return CartItemModel(
        id: (doc.data() as dynamic)['id'],
        imgUrl: (doc.data() as dynamic)['imgUrl'],
        imgPath: (doc.data() as dynamic)['imgPath'],
        quantity: (doc.data() as dynamic)['quantity']);
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
