import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IDBService {
  Future<void> addPropertyToDocuments(
      {required String collection,
      required String property,
      required dynamic value});
}

class DBService extends IDBService {
  @override
  Future<void> addPropertyToDocuments(
      {required String collection,
      required String property,
      required dynamic value}) async {
    try {
      final CollectionReference colRef =
          FirebaseFirestore.instance.collection(collection);
      QuerySnapshot querySnapshot = await colRef.get();
      List<DocumentSnapshot> docs = querySnapshot.docs;
      for (int i = 0; i < docs.length; i++) {
        await colRef.doc(docs[i].id).update(
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
