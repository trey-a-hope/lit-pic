import 'package:cloud_firestore/cloud_firestore.dart';

class LitPicModel {
  final String dimensions;
  final String endColor;
  final String id;
  final String imgUrl;
  final int printMinutes;
  final String startColor;
  final String title;

  LitPicModel(
      {required this.dimensions,
      required this.endColor,
      required this.id,
      required this.imgUrl,
      required this.printMinutes,
      required this.startColor,
      required this.title});

  factory LitPicModel.fromDoc({required DocumentSnapshot doc}) {
    return LitPicModel(
      dimensions: (doc.data() as dynamic)['dimensions'],
      endColor: (doc.data() as dynamic)['endColor'],
      id: (doc.data() as dynamic)['id'],
      imgUrl: (doc.data() as dynamic)['imgUrl'],
      printMinutes: (doc.data() as dynamic)['printMinutes'],
      startColor: (doc.data() as dynamic)['startColor'],
      title: (doc.data() as dynamic)['title'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dimensions': dimensions,
      'endColor': endColor,
      'id': id,
      'imgUrl': imgUrl,
      'printMinutes': printMinutes,
      'startColor': startColor,
      'title': title
    };
  }
}
