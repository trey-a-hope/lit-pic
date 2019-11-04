import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/pages/shop/checkout_page.dart';
import 'package:litpic/services/image_cart.dart';
import 'package:litpic/services/modal.dart';
import 'package:litpic/services/auth.dart';
import 'package:litpic/models/database/user.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class ShoppingPage extends StatefulWidget {
  @override
  State createState() => ShoppingPageState();
}

class ShoppingPageState extends State<ShoppingPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;
  bool _isLoggedIn = false;

  File _image;
  List<File> _images = List<File>();

  final double price = 15.00;

  @override
  void initState() {
    super.initState();
    getIt<Auth>().onAuthStateChanged().listen(
      (firebaseUser) {
        setState(
          () {
            _isLoggedIn = firebaseUser != null;
            if (_isLoggedIn) {
              _load();
            } else {
              _isLoading = false;
            }
          },
        );
      },
    );
  }

  _load() async {
    try {
      _images = getIt<ImageCart>().getImages();
      _currentUser = await getIt<Auth>().getCurrentUser();
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<Modal>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  _showSelectImageDialog() {
    return Platform.isIOS ? _iOSBottomSheet() : _androidDialog();
  }

  _iOSBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(source: ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text('Choose From Gallery'),
                onPressed: () => _handleImage(source: ImageSource.gallery),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Add Photo'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () => _handleImage(source: ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text('Choose From Gallery'),
                onPressed: () => _handleImage(source: ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  _handleImage({@required ImageSource source}) async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile != null) {
      imageFile = await _cropImage(imageFile: imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _cropImage({@required File imageFile}) async {
    File croppedImage =
        await ImageCropper.cropImage(sourcePath: imageFile.path);
    return croppedImage;
  }

  _addImageToCart() async {
    if (_image == null) {
      getIt<Modal>().showAlert(
          context: context,
          title: 'Error',
          message: 'Please select an image first.');
      return;
    }

    setState(() {
      getIt<ImageCart>().addImage(image: _image);
      _image = null;
    });
  }

  _emptyImages() async {
    bool confirm = await getIt<Modal>().showConfirmation(
        context: context, title: 'Empty Images', message: 'Are you sure?');
    if (confirm) {
      getIt<ImageCart>().deleteImages();
      setState(() {});
    }
  }

  _deleteImage({@required File image}) async {
    bool confirm = await getIt<Modal>().showConfirmation(
        context: context, title: 'Delete Image', message: 'Are you sure?');
    if (confirm) {
      getIt<ImageCart>().deleteImage(image: image);
      setState(() {});
    }
  }

  String _price() {
    FlutterMoneyFormatter fmf =
        FlutterMoneyFormatter(amount: price * _images.length);
    return fmf.output.symbolOnLeft;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Spinner()
        : _isLoggedIn ? isLoggedInView() : LoggedOutView();
  }

  Widget isLoggedInView() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            _showSelectImageDialog();
          },
          child: Container(
            height: width,
            width: width,
            color: Colors.grey[300],
            child: _image == null
                ? Icon(
                    Icons.add_a_photo,
                    color: Colors.white70,
                    size: 150,
                  )
                : Image(
                    image: FileImage(_image),
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Images',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                _price(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _images.length,
            itemBuilder: (BuildContext buildContext, int index) {
              return _cartImage(image: _images[index]);
            },
          ),
        ),
        RaisedButton(
          color: Colors.white,
          child: Text('Add Image To Images'),
          onPressed: () => _addImageToCart(),
        ),
        _images.isNotEmpty
            ? RaisedButton(
                color: Colors.white,
                child: Text('Proceed to Checkout'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(
                      images: _images,
                    ),
                  ),
                ),
              )
            : Container(),
        _images.isNotEmpty
            ? RaisedButton(
                color: Colors.white,
                child: Text('Empty Images'),
                onPressed: () => _emptyImages(),
              )
            : Container()
      ],
    );
  }

  Widget _cartImage({@required File image}) {
    return GestureDetector(
      onTap: () => _deleteImage(image: image),
      child: Container(
        width: 100,
        child: Image(
          image: FileImage(image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
