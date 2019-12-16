import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LitPic {
  final String dimensions;
  final String endColor;
  final String id;
  final String imgUrl;
  final int printMinutes;
  final String startColor;
  final String title;

  LitPic(
      {@required this.dimensions,
      @required this.endColor,
      @required this.id,
      @required this.imgUrl,
      @required this.printMinutes,
      @required this.startColor,
      @required this.title});

  factory LitPic.fromDoc({@required DocumentSnapshot doc}) {
    return LitPic(
      dimensions: doc.data['dimensions'],
      endColor: doc.data['endColor'],
      id: doc.data['id'],
      imgUrl: doc.data['imgUrl'],
      printMinutes: doc.data['printMinutes'],
      startColor: doc.data['startColor'],
      title: doc.data['title'],
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
