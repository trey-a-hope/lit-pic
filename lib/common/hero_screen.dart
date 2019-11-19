
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HeroScreen extends StatelessWidget {
  final String imgUrl;
  final String imgPath;

  HeroScreen({@required this.imgUrl, @required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: imgUrl == null ? imgPath : imgUrl,
            child: imgUrl == null
                ? Image.asset(imgPath)
                : CachedNetworkImage(
                    imageUrl: imgUrl,
                  ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
