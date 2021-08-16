import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/litpic_model.dart';

abstract class ILitPicService {
  Future<String> create({required LitPicModel litPic});
  Future<List<LitPicModel>> list({required int limit});
}

class LitPicService extends ILitPicService {
  final CollectionReference _litPicsDB =
      FirebaseFirestore.instance.collection('Lit Pics');

  @override
  Future<List<LitPicModel>> list({required int limit}) async {
    try {
      List<DocumentSnapshot> docs = (await _litPicsDB.limit(limit).get()).docs;

      List<LitPicModel> litPics = docs
          .map(
            (doc) => LitPicModel.fromDoc(doc: doc),
          )
          .toList();

      return litPics;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> create({required LitPicModel litPic}) async {
    try {
      DocumentReference docRef = _litPicsDB.doc();
      litPic.id = docRef.id;
      _litPicsDB.doc(litPic.id).set(litPic.toMap());

      return litPic.id!;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
