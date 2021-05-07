import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:litpic/models/litpic_model.dart';

abstract class ILitPicService {
  Future<List<LitPicModel>> retrieveLitPics();
}

class LitPicService extends ILitPicService {
  final CollectionReference _litPicsDB =
      FirebaseFirestore.instance.collection('Lit Pics');

  @override
  Future<List<LitPicModel>> retrieveLitPics() async {
    try {
      List<DocumentSnapshot> docs = (await _litPicsDB.get()).docs;
      List<LitPicModel> litPics = [];
      for (int i = 0; i < docs.length; i++) {
        litPics.add(
          LitPicModel.fromDoc(doc: docs[i]),
        );
      }

      return litPics;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
