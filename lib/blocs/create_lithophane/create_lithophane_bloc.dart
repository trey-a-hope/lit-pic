import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/cart_item_service.dart';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/cart_item_model.dart';
import 'package:litpic/models/sku_model.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/image_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe_sku_service.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:uuid/uuid.dart';

part 'create_lithophane_event.dart';
part 'create_lithophane_state.dart';
part 'create_lithophane_page.dart';

class CreateLithophaneBloc
    extends Bloc<CreateLithophaneEvent, CreateLithophaneState> {
  CreateLithophaneBloc() : super(CreateLithophaneInitialState());

  UserModel _currentUser;
  SkuModel _sku;
  int _quantity = 1;

  @override
  Stream<CreateLithophaneState> mapEventToState(
    CreateLithophaneEvent event,
  ) async* {
    yield CreateLithophaneLoadingState();

    if (event is LoadPageEvent) {
      _currentUser = await locator<AuthService>().getCurrentUser();
      _sku = await locator<StripeSkuService>().retrieve(skuID: SKU_UD);

      yield CreateLithophaneLoadedState(
          sku: _sku, quantity: _quantity, imageUploaded: false);
    }

    if (event is UpdateQuantityEvent) {
      _quantity = event.quantity;

      yield CreateLithophaneLoadedState(
        sku: _sku,
        quantity: _quantity,
        imageUploaded: false,
      );
    }

    if (event is AddToCartEvent) {
      final PickedFile image = event.image;
      try {
        //Upload image to storage.
        final String photoID = Uuid().v1();
        final String imgPath = 'Users/${_currentUser.uid}/Orders/$photoID';
        final String imgUrl = await locator<StorageService>()
            .uploadImage(file: image, imgPath: imgPath);

        //Save cart item to database.
        await locator<CartItemService>().createCartItem(
          uid: _currentUser.uid,
          cartItem: CartItemModel(
            id: null,
            imgUrl: imgUrl,
            imgPath: imgPath,
            quantity: _quantity,
          ),
        );

        //Reset quantity to 1.
        _quantity = 1;

        yield CreateLithophaneLoadedState(
            sku: _sku, quantity: _quantity, imageUploaded: true);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
