import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/user_model.dart';

abstract class IUserService {
  Future<void> createUser({required UserModel user});
  Future<UserModel> retrieveUser({required String uid});
  Future<UserModel> retrieveUserByCustomerID({required String customerID});
  Future<void> updateUser(
      {required String uid, required Map<String, dynamic> data});
  Future<void> deleteUser({required String uid});
  // Future<List<UserModel>> retrieveUsers({bool isAdmin, int limit});
}

class UserService extends IUserService {
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('Users');

  @override
  Future<void> createUser({required UserModel user}) async {
    try {
      DocumentReference docRef = _usersDB.doc(user.uid);

      docRef.set(user.toMap());

      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel> retrieveUser({required String uid}) async {
    try {
      DocumentSnapshot documentSnapshot = await _usersDB.doc(uid).get();
      return UserModel.fromDoc(doc: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserModel> retrieveUserByCustomerID(
      {required String customerID}) async {
    try {
      DocumentSnapshot documentSnapshot =
          (await _usersDB.where('customerID', isEqualTo: customerID).get())
              .docs
              .first;
      return UserModel.fromDoc(doc: documentSnapshot);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateUser(
      {required String uid, required Map<String, dynamic> data}) async {
    try {
      await _usersDB.doc(uid).update(data);
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteUser({required String uid}) async {
    try {
      await _usersDB.doc(uid).delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
