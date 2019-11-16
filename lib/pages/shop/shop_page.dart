import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:litpic/common/good_button.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/image_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class ShopPage extends StatefulWidget {
  @override
  State createState() => ShopPageState();
}

class ShopPageState extends State<ShopPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;
  bool _isPosting = false;

  File _image;

  final double price = 15.00;

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    try {
      _currentUser = await getIt<AuthService>().getCurrentUser();
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<ModalService>().showAlert(
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
      imageFile = await getIt<ImageService>().cropImage(imageFile: imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  _addImageToCart() async {
    if (_image == null) {
      getIt<ModalService>().showAlert(
          context: context,
          title: 'Error',
          message: 'Please select an image first.');
      return;
    }

    try {
      //Start loading indicator.
      setState(() {
        _isPosting = true;
      });

      //Upload image to storage.
      final String photoID = Uuid().v1();
      final String imgPath = 'Users/${_currentUser.id}/Orders/$photoID';
      String imgUrl = await getIt<StorageService>()
          .uploadImage(file: _image, imgPath: imgPath);

      //Save cart item to database.
      getIt<DBService>().createCartItem(
        userID: _currentUser.id,
        cartItem: CartItem(
            id: null,
            imgUrl: imgUrl,
            imgPath: imgPath,
            title: 'Lithophane',
            productID: null,
            quantity: 1),
      );

      //Clear image and stop loading indicator.
      setState(() {
        _image = null;
        _isPosting = false;
      });

      //Display success modal.
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Got It',
        message: 'This item has been added to your shopping cart.',
      );
    } catch (e) {
      setState(() {
        _isPosting = false;
      });
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  String _price() {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: price);
    return fmf.output.symbolOnLeft;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Spinner() : view();
  }

  Widget view() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        _isPosting
            ? LinearProgressIndicator(
                backgroundColor: Colors.blue[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              )
            : SizedBox.shrink(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Lithophane Price',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text(
                    _price(),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              Divider(),
              Text(
                'Choose an image for your lithophane.',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        GoodButton(
          onPressed: () => _addImageToCart(),
          buttonColor: Colors.amber,
          text: 'ADD LITHOPHANE TO CART',
          textColor: Colors.white,
        ),
      ],
    );
  }
}
