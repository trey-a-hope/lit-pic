import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/blocs/checkout/checkout_bloc.dart';
import 'package:litpic/common/lit_pic_app_bar.dart';
import 'package:litpic/common/lit_pic_list_views.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/mixins/ui_properties_mixin.dart';
import 'package:litpic/models/cart_item_model.dart';
import 'package:litpic/models/price_model.dart';
import 'package:litpic/models/session_model.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/cart_item_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/services/stripe_price_service.dart';
import 'package:litpic/services/stripe_session_service.dart';
import 'package:litpic/views/cart_item_view.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_page.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitialState());

  late UserModel _currentUser;
  late List<CartItemModel> _cartItems;
  double _shippingFee = 0.0;
  late PriceModel _price;

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    yield CartLoadingState();

    if (event is LoadPageEvent) {
      try {
        _currentUser = await locator<AuthService>().getCurrentUser();
        _currentUser.customer = await locator<StripeCustomerService>()
            .retrieve(customerID: _currentUser.customerID);
        _price = await locator<StripePriceService>().get(priceID: PRICE_ID);

        Stream<QuerySnapshot<Object?>> snapshots =
            locator<CartItemService>().streamCartItems(uid: _currentUser.uid);

        snapshots.listen((event) {
          add(RefreshEvent());
        });
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is IncrementQuantityEvent) {
      try {
        final CartItemModel cartItem = event.cartItem;

        await locator<CartItemService>().updateCartItem(
          uid: _currentUser.uid,
          cartItemID: cartItem.id!,
          data: {
            'quantity': cartItem.quantity + 1,
          },
        );

        add(RefreshEvent());
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is DecrementQuantityEvent) {
      try {
        final CartItemModel cartItem = event.cartItem;

        await locator<CartItemService>().updateCartItem(
            uid: _currentUser.uid,
            cartItemID: cartItem.id!,
            data: {'quantity': cartItem.quantity - 1});

        add(RefreshEvent());
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is DeleteCartItemEvent) {
      try {
        final CartItemModel cartItem = event.cartItem;

        await locator<CartItemService>()
            .deleteCartItem(uid: _currentUser.uid, cartItemID: cartItem.id!);
        await locator<StorageService>().deleteImage(imgPath: cartItem.imgPath);

        add(RefreshEvent());
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is RefreshEvent) {
      _cartItems = await locator<CartItemService>()
          .retrieveCartItems(uid: _currentUser.uid);

      yield CartLoadedState(
        currentUser: _currentUser,
        subTotal: _getSubTotal(),
        total: _getSubTotal(),
        shippingFee: _shippingFee,
        cartItems: _cartItems,
        price: _price,
      );
    }

    if (event is ProceedToStripeCheckout) {
      SessionModel session = SessionModel(
        customer: _currentUser.customer!.id,
        // lineItems: [
        //   {
        //     'price': '$PRICE_ID',
        //     'quantity': 2,
        //   },
        // ],
      );

      String sessionID = await locator<StripeSessionService>().create(
        session: session,
      );

      print('SessionID: $sessionID');

      SessionModel newSession = await locator<StripeSessionService>().retrieve(
        sessionID: sessionID,
      );

      print('URL: ${newSession.url}');

      yield StripeCheckoutState(session: newSession);
    }
  }

  double _getSubTotal() {
    double total = 0.0;
    _cartItems.forEach((cartItem) {
      total += cartItem.quantity * _price.unitAmount;
    });
    return total;
  }
}
