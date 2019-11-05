import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class StorageService {
  Future<String> uploadImage({@required File file, @required String path});
}

class StorageServiceImplementation extends StorageService {
  //Add validation to determine if file is image or not...
  @override
  Future<String> uploadImage(
      {@required File file, @required String path}) async {
    try {
      final StorageReference ref = FirebaseStorage().ref().child(path);
      final StorageUploadTask uploadTask = ref.putFile(file);
      StorageReference sr = (await uploadTask.onComplete).ref;
      return (await sr.getDownloadURL()).toString();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
