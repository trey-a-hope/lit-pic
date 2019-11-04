import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/services/validater.dart';

abstract class ImageCart {
  void addImage({@required File image});
  List<File> getImages();
  void deleteImage({@required File image});
  void deleteImages();
}

class ImageCartImplementation extends ImageCart {
  List<File> images = List<File>();

  @override
  void addImage({File image}) {
    images.add(image);
  }

  @override
  List<File> getImages() {
    return images;
  }

  @override
  void deleteImage({File image}) {
    images.remove(image);
  }

  @override
  void deleteImages() {
    images.clear();
  }
}
