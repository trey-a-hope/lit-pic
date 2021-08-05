//TODO: Find better name.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/cart_item_model.dart';

class FirebaseOrderModel {
  final String id;
  final String name;
  final String email;
  final List<CartItemModel> cartItems;

  FirebaseOrderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.cartItems,
  });

  factory FirebaseOrderModel.fromDoc({required DocumentSnapshot doc}) {
    return FirebaseOrderModel(
      id: (doc.data() as dynamic)['id'],
      name: (doc.data() as dynamic)['name'],
      email: (doc.data() as dynamic)['email'],
      cartItems: (doc.data() as dynamic)['cartItems'],
     );
  }
}
