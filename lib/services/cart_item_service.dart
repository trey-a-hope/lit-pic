import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/cart_item_model.dart';

abstract class ICartItemService {
  //Cart Item
  Future<void> createCartItem(
      {required String uid, required CartItemModel cartItem});
  Future<List<CartItemModel>> retrieveCartItems({required String uid});
  Future<void> updateCartItem(
      {required String uid,
      required String cartItemID,
      required Map<String, dynamic> data});
  Future<void> deleteCartItem(
      {required String uid, required String cartItemID});
  Stream<QuerySnapshot<Object?>> streamCartItems({required String uid});
}

class CartItemService extends ICartItemService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<void> createCartItem(
      {required String uid, required CartItemModel cartItem}) async {
    try {
      final CollectionReference colRef =
          _usersDB.doc(uid).collection('cartItems');

      final DocumentReference docRef = colRef.doc();

      cartItem.id = docRef.id;

      await docRef.set(
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
  Future<List<CartItemModel>> retrieveCartItems({required String uid}) async {
    try {
      CollectionReference colRef = _usersDB.doc(uid).collection('cartItems');
      List<DocumentSnapshot> docs = (await colRef.get()).docs;
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
      {required String uid,
      required String cartItemID,
      required Map<String, dynamic> data}) async {
    try {
      CollectionReference colRef = _usersDB.doc(uid).collection('cartItems');
      DocumentReference docRef = colRef.doc(cartItemID);
      await docRef.update(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteCartItem(
      {required String uid, required String cartItemID}) async {
    try {
      //Delete cart item from database.
      CollectionReference colRef = _usersDB.doc(uid).collection('cartItems');
      await colRef.doc(cartItemID).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Stream<QuerySnapshot<Object?>> streamCartItems({required String uid}) {
    try {
      CollectionReference colRef = _usersDB.doc(uid).collection('cartItems');
      Stream<QuerySnapshot<Object?>> snapshots = colRef.snapshots();
      return snapshots;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
