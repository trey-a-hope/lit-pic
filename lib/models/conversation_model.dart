// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:dash_chat/dash_chat.dart';
// import 'package:flutter/material.dart';
// import 'package:litpic/models/user_model.dart';

// class ConversationModel {
//   DocumentReference reference;
//   String? imageUrl;
//   String lastMessage;
//   DateTime time;
//   String title;
//   bool? read;
//   // ChatUser sendee;
//   // ChatUser sender;
//   UserModel? oppositeUser;

//   ConversationModel({
//     required String title,
//     required String lastMessage,
//     required this.imageUrl,
//     // ChatUser sender,
//     // ChatUser sendee,
//     DocumentReference? reference,
//     required DateTime time,
//     this.read,
//     this.oppositeUser,
//    });

//   static ConversationModel extractDocument(DocumentSnapshot ds) {
//     Map<String, dynamic> data = (ds.data() as dynamic);
//     return ConversationModel(
//       title: data['title'],
//       lastMessage: data['lastMessage'],
//       imageUrl: data['imageUrl'],
//       time: data['time'].toDate(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'lastMessage': lastMessage,
//       'imageUrl': imageUrl,
//       'time': time
//     };
//   }
// }
