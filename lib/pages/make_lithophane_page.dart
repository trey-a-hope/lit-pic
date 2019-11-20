import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:litpic/common/good_button.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/main.dart';
import 'package:litpic/models/database/cart_item.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/models/stripe/sku.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/image_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe/sku.dart';
import 'package:litpic/titleView.dart';
import 'package:uuid/uuid.dart';

class MakeLithophanePage extends StatefulWidget {
  final AnimationController animationController;

  const MakeLithophanePage({Key key, this.animationController})
      : super(key: key);
  @override
  _MakeLithophanePageState createState() => _MakeLithophanePageState();
}

class _MakeLithophanePageState extends State<MakeLithophanePage>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;
  final GetIt getIt = GetIt.I;
  int quantity = 1;
  ColorName _selectedColor = filamentColors[0];
  File _image;
  bool _isLoading = false;
  User _currentUser;
  Sku _sku;

  @override
  void initState() {
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    // addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    var count = 9;
    listViews.clear();

    listViews.add(
      GestureDetector(
        onTap: () {
          _showSelectImageDialog();
        },
        child: Container(
          height: CommonThings.width,
          width: CommonThings.width,
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
    );

    listViews.add(
      _isLoading
          ? LinearProgressIndicator(
              backgroundColor: Colors.blue[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            )
          : SizedBox.shrink(),
    );

    listViews.add(
      SizedBox(
        height: 20,
      ),
    );

    listViews.add(
      TitleView(
        showExtra: false,
        titleTxt: 'Choose Quantity',
        subTxt: 'Details',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(SizedBox(
      height: 20,
    ));

    listViews.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _decrementButton(),
          Text(
            quantity.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: LitPicTheme.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 32,
              color: LitPicTheme.nearlyDarkBlue,
            ),
          ),
          _incrementButton(),
        ],
      ),
    );

    listViews.add(SizedBox(
      height: 20,
    ));

    listViews.add(
      TitleView(
        showExtra: false,
        titleTxt: 'Choose Color',
        subTxt: 'Details',
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(SizedBox(
      height: 20,
    ));

    listViews.add(
      Container(
        height: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filamentColors.length,
            itemBuilder: (context, index) {
              return colorCircle(colorName: filamentColors[index]);
            }),
      ),
    );

    listViews.add(
      Padding(
        padding: EdgeInsets.all(15),
        child: GoodButton(
          onPressed: () {
            _addImageToCart();
          },
          buttonColor: _selectedColor.color,
          text:
              'ADD LITHOPHANE TO CART - ${getIt<FormatterService>().money(amount: _sku.price * quantity)}',
          textColor: (_selectedColor.color == Colors.white ||
                  _selectedColor.color == Colors.yellow)
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
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
        _isLoading = true;
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
            color: _selectedColor.name,
            quantity: quantity),
      );

      //Clear image and stop loading indicator.
      setState(() {
        _image = null;
        _isLoading = false;
      });

      //Display success modal.
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Got It',
        message: 'This item has been added to your shopping cart.',
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  Widget _decrementButton() {
    return InkWell(
      onTap: () {
        setState(() {
          if (quantity > 1) {
            quantity -= 1;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: LitPicTheme.nearlyWhite,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: LitPicTheme.nearlyDarkBlue.withOpacity(0.4),
                offset: Offset(4.0, 4.0),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            Icons.remove,
            color: LitPicTheme.nearlyDarkBlue,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _incrementButton() {
    return InkWell(
      onTap: () {
        setState(() {
          quantity += 1;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: LitPicTheme.nearlyWhite,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: LitPicTheme.nearlyDarkBlue.withOpacity(0.4),
                offset: Offset(4.0, 4.0),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            Icons.add,
            color: LitPicTheme.nearlyDarkBlue,
            size: 24,
          ),
        ),
      ),
    );
  }

  Future<bool> load() async {
    try {
      //Load user.
      _currentUser = await getIt<AuthService>().getCurrentUser();

      return true;
    } catch (e) {
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
      return false;
    }
  }

  Future<void> fetchLithophaneSku() async {
    final String skuID = await getIt<DBService>().retrieveSkuID();
    _sku = await getIt<StripeSku>().retrieve(skuID: skuID);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LitPicTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    List<Future> futures = List<Future>();
    futures.add(load());
    futures.add(fetchLithophaneSku());
    return FutureBuilder(
      future: Future.wait(futures),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Spinner();
        } else {
          addAllListData();
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: LitPicTheme.white.withOpacity(topBarOpacity),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color:
                              LitPicTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Make Your Lithophane",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: LitPicTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: LitPicTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget colorCircle({@required ColorName colorName}) {
    final double size = 50;

    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedColor = colorName;
          });
        },
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: colorName.color,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: LitPicTheme.nearlyDarkBlue.withOpacity(0.4),
                  offset: Offset(4.0, 4.0),
                  blurRadius: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
