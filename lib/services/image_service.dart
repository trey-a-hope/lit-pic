import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

abstract class IImageService {
  Future<XFile> cropImage({required XFile imageFile});
}

class ImageService extends IImageService {
  @override
  Future<XFile> cropImage({required XFile imageFile}) async {
    File? croppedImage =
        await ImageCropper.cropImage(sourcePath: imageFile.path);

    if (croppedImage == null) {
      throw PlatformException(
        message: 'Image null.',
        code: '1000',
      );
    }

    return XFile(croppedImage.path);
  }
}
