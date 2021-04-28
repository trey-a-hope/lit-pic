import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

abstract class IImageService {
  Future<File> cropImage({@required File imageFile});
}

class ImageService extends IImageService {
  @override
  Future<File> cropImage({File imageFile}) async {
    File croppedImage =
        await ImageCropper.cropImage(sourcePath: imageFile.path);
    return croppedImage;
  }
}
