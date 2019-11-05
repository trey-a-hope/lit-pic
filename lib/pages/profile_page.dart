import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/image_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe/customer.dart';

class ProfilePage extends StatefulWidget {
  @override
  State createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  bool _isLoggedIn = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    getIt<AuthService>().onAuthStateChanged().listen(
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
      _currentUser = await getIt<AuthService>().getCurrentUser();
      _currentUser.customer = await getIt<StripeCustomer>()
          .retrieve(customerID: _currentUser.customerID);
      print(_currentUser.customer.email);
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

      //Upload image to Storage
      String imgUrl = await getIt<StorageService>().uploadImage(
          imgPath: 'Users/${_currentUser.id}/profilePic', file: imageFile);

      //Update imgUrl for user.
      await getIt<DBService>()
          .updateUser(userID: _currentUser.id, data: {'imgUrl': imgUrl});

      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Spinner()
        : _isLoggedIn ? isLoggedInView() : LoggedOutView();
  }

  Widget isLoggedInView() {
    return ListView(
      children: <Widget>[
        Container(
            height: 200,
            color: Colors.grey,
            child: GestureDetector(
              onTap: () => _showSelectImageDialog(),
              child: _currentUser.imgUrl == null
                  ? CircleAvatar(
                      child: Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      child: Image(
                        image: CachedNetworkImageProvider(_currentUser.imgUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
                color: _currentIndex == 0 ? Colors.greenAccent : Colors.white,
                child: Text('Info'),
                onPressed: () => {
                      setState(() {
                        _currentIndex = 0;
                      })
                    }),
            RaisedButton(
                color: _currentIndex == 1 ? Colors.greenAccent : Colors.white,
                child: Text('Orders'),
                onPressed: () => {
                      setState(() {
                        _currentIndex = 1;
                      })
                    }),
            RaisedButton(
                color: _currentIndex == 2 ? Colors.greenAccent : Colors.white,
                child: Text('Saved Cards'),
                onPressed: () => {
                      setState(() {
                        _currentIndex = 2;
                      })
                    }),
          ],
        ),
        _currentIndex == 0 ? _infoView() : SizedBox.shrink(),
        _currentIndex == 1 ? _ordersView() : SizedBox.shrink(),
        _currentIndex == 2 ? _savedCardsView() : SizedBox.shrink()
      ],
    );
  }

  Widget _infoView() {
    return Column(
      children: <Widget>[
        Text('Name'),
        Text(_currentUser.customer.name),
        Text('Email'),
        Text(_currentUser.customer.email),
      ],
    );
  }

  Widget _ordersView() {
    return Text('Currently No Orders');
  }

  Widget _savedCardsView() {
    return Text('Currently No Saved Cards');
  }
}
