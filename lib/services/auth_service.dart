import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:litpic/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import '../constants.dart';

abstract class IAuthService {
  Future<UserModel> getCurrentUser();
  Future<void> signOut();
  Stream<User?> onAuthStateChanged();
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password});
  Future<void> updatePassword({required String password});
  Future<void> updateEmail({required String email});

  Future<void> deleteUser({required String password});
  Future<void> deleteUsers();
  Future<void> resetPassword({required String email});
}

class AuthService extends IAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersDB =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      User firebaseUser = _auth.currentUser!;
      final DocumentSnapshot documentSnapshot =
          await _usersDB.doc(firebaseUser.uid).get();
      return UserModel.fromDoc(doc: documentSnapshot);
    } catch (e) {
      throw Exception('Could not fetch user at this time.');
    }
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  @override
  Stream<User?> onAuthStateChanged() {
    return _auth.idTokenChanges();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  Future<void> updatePassword({required String password}) async {
    try {
      User firebaseUser = _auth.currentUser!;
      await firebaseUser.updatePassword(password);
      return;
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> deleteUser({required String password}) async {
    try {
      //Get current user of the app.
      User firebaseUser = _auth.currentUser!;

      //Re-create credential based on user email and password.
      AuthCredential credential = EmailAuthProvider.credential(
          email: firebaseUser.email!, password: password);

      //Re-authenticate the user with credential.
      firebaseUser.reauthenticateWithCredential(credential);

      //Delete them from auth.
      await firebaseUser.delete();
      return;
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> updateEmail({required String email}) async {
    try {
      return await _auth.currentUser!.updateEmail(email);
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }

  @override
  Future<void> deleteUsers() async {
    http.Response response = await http.post(
      Uri.parse('${GCF_ENDPOINT}AdminAuthDeleteUsers'),
      body: json.encode({'adminDocId': ADMIN_DOC_ID}),
      headers: {'content-type': 'application/json'},
    );

    try {
      Map map = json.decode(response.body);
      if (map['statusCode'] == null) {
        return map['id'];
      } else {
        throw PlatformException(
          message: map['raw']['message'],
          code: map['raw']['statusCode'].toString(),
        );
      }
    } on PlatformException catch (e) {
      throw PlatformException(message: e.message, code: e.code);
    }
  }
}
