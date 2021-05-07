import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class IStorageService {
  Future<String> uploadImage(
      {@required PickedFile file, @required String imgPath});
  Future<void> deleteImage({@required String imgPath});
}

class StorageService extends IStorageService {
  //Add validation to determine if file is image or not...
  @override
  Future<String> uploadImage(
      {@required PickedFile file, @required String imgPath}) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(imgPath);
      final UploadTask uploadTask = ref.putFile(File(file.path));
      final Reference sr = (await uploadTask).ref;
      return (await sr.getDownloadURL()).toString();
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  @override
  Future<void> deleteImage({String imgPath}) async {
    try {
      final Reference ref = FirebaseStorage.instance.ref().child(imgPath);
      await ref.delete();
      return;
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
