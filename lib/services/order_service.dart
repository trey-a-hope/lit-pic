import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/firebase_order_model.dart';

abstract class IOrderService {
  Future<List<FirebaseOrderModel>> list({
    required String customerID,
    required String status,
  });
}

class OrderService extends IOrderService {
  final CollectionReference _ordersDB =
      FirebaseFirestore.instance.collection('Orders');

  @override
  Future<List<FirebaseOrderModel>> list({
    required String customerID,
    required String status,
  }) async {
    try {
      QuerySnapshot<Object?> querySnapshot = (await _ordersDB
          .where('customerID', isEqualTo: customerID)
          .where('status', isEqualTo: status)
          .get());

      List<FirebaseOrderModel> orders = querySnapshot.docs
          .map(
            (e) => FirebaseOrderModel.fromDoc(doc: e),
          )
          .toList();

      return orders;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
