import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

abstract class IImageService {
  Future<PickedFile> cropImage({@required PickedFile imageFile});
}

class ImageService extends IImageService {
  @override
  Future<PickedFile> cropImage({@required PickedFile imageFile}) async {
    File croppedImage =
        await ImageCropper.cropImage(sourcePath: imageFile.path);
    return PickedFile(croppedImage.path);
  }
}
