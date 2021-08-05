import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/common/lit_pic_app_bar.dart';
import 'package:litpic/common/lit_pic_list_views.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/mixins/ui_properties_mixin.dart';
import 'package:litpic/models/price_model.dart';
import 'package:litpic/models/product_model.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/cart_item_service.dart';
import 'package:litpic/services/stripe_price_service.dart';
import 'package:litpic/services/stripe_product_service.dart';
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

  late UserModel _currentUser;
  late PriceModel _price;
  int _quantity = 1;

  @override
  Stream<CreateLithophaneState> mapEventToState(
    CreateLithophaneEvent event,
  ) async* {
    yield CreateLithophaneLoadingState();

    if (event is LoadPageEvent) {
      try {
        _currentUser = await locator<AuthService>().getCurrentUser();

        _price = await locator<StripePriceService>().get(priceID: PRICE_ID);

        print(_price);

        yield CreateLithophaneLoadedState(
          price: _price,
          quantity: _quantity,
          imageUploaded: false,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is UpdateQuantityEvent) {
      _quantity = event.quantity;

      yield CreateLithophaneLoadedState(
        price: _price,
        quantity: _quantity,
        imageUploaded: false,
      );
    }

    if (event is AddToCartEvent) {
      final XFile image = event.image;
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
          price: _price,
          quantity: _quantity,
          imageUploaded: true,
        );
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
