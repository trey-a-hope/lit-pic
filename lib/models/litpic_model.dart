import 'package:cloud_firestore/cloud_firestore.dart';

class LitPicModel {
  final String dimensions;
  String? id;
  final String imgUrl;
  final int printMinutes;
  final String title;

  LitPicModel({
    required this.dimensions,
    required this.id,
    required this.imgUrl,
    required this.printMinutes,
    required this.title,
  });

  factory LitPicModel.fromDoc({required DocumentSnapshot doc}) {
    return LitPicModel(
      dimensions: (doc.data() as dynamic)['dimensions'],
      id: (doc.data() as dynamic)['id'],
      imgUrl: (doc.data() as dynamic)['imgUrl'],
      printMinutes: (doc.data() as dynamic)['printMinutes'],
      title: (doc.data() as dynamic)['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dimensions': dimensions,
      'id': id,
      'imgUrl': imgUrl,
      'printMinutes': printMinutes,
      'title': title
    };
  }
}
