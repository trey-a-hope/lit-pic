import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:litpic/models/user_model.dart';

class ConversationModel {
  DocumentReference reference;
  String imageUrl;
  String lastMessage;
  DateTime time;
  String title;
  bool read;
  // ChatUser sendee;
  // ChatUser sender;

  ConversationModel(
      {@required String title,
      @required String lastMessage,
      @required String imageUrl,
      // ChatUser sender,
      // ChatUser sendee,
      DocumentReference reference,
      @required DateTime time,
      bool read,
      UserModel oppositeUser}) {
    this.title = title;
    this.lastMessage = lastMessage;
    this.imageUrl = imageUrl;
    // this.sender = sender;
    // this.sendee = sendee;
    this.reference = reference;
    this.time = time;
    this.read = read;
  }

  static ConversationModel extractDocument(DocumentSnapshot ds) {
    Map<String, dynamic> data = ds.data();
    return ConversationModel(
      title: data['title'],
      lastMessage: data['lastMessage'],
      imageUrl: data['imageUrl'],
      time: data['time'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'lastMessage': lastMessage,
      'imageUrl': imageUrl,
      'time': time
    };
  }
}
