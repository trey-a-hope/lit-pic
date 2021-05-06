import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class IDBService {
  Future<void> addPropertyToDocuments(
      {@required String collection,
      @required String property,
      @required dynamic value});
}

class DBService extends IDBService {
  @override
  Future<void> addPropertyToDocuments(
      {String collection, String property, dynamic value}) async {
    try {
      final CollectionReference colRef =
          Firestore.instance.collection(collection);
      QuerySnapshot querySnapshot = await colRef.getDocuments();
      List<DocumentSnapshot> docs = querySnapshot.documents;
      for (int i = 0; i < docs.length; i++) {
        await colRef.document(docs[i].documentID).updateData(
          {property: value},
        );
      }
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
