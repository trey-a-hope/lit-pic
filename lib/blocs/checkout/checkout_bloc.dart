import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/common/lit_pic_app_bar.dart';
import 'package:litpic/common/lit_pic_list_views.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/mixins/ui_properties_mixin.dart';
import 'package:litpic/models/cart_item_model.dart';
import 'package:litpic/models/credit_card_model.dart';
import 'package:litpic/models/sku_model.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/pages/profile/edit_shipping_info_page.dart';
import 'package:litpic/pages/profile/saved_cards_page.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/cart_item_service.dart';
import 'package:litpic/services/fcm_service.dart';
import 'package:litpic/services/formatter_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/services/stripe_order_service.dart';
import 'package:litpic/services/stripe_sku_service.dart';
import 'package:litpic/services/user_service.dart';
import 'package:litpic/views/cart_item_bought_view.dart';
import 'package:litpic/views/credit_card_view.dart';
import 'package:litpic/views/data_box_view.dart';
import 'package:litpic/views/pay_flow_diagram_view.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/title_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_page.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial());

  late UserModel _currentUser;
  late SkuModel _sku;
  late List<CartItemModel> _cartItems;
  late SharedPreferences _prefs;
  int _checkoutProcessStep = 0;

  CheckoutState _getCheckoutState() {
    switch (_checkoutProcessStep) {
      case 0:
        return CheckoutShippingState(currentUser: _currentUser);
      case 1:
        return CheckoutPaymentState(currentUser: _currentUser);
      case 2:
        double subTotal = _prefs.getDouble('subTotal') ?? 0;
        double shippingFee = _prefs.getDouble('shippingFee') ?? 0;
        double total = _prefs.getDouble('total') ?? 0;

        return CheckoutSubmitState(
          currentUser: _currentUser,
          shippingFee: shippingFee,
          cartItems: _cartItems,
          subTotal: subTotal,
          total: total,
          sku: _sku,
        );
      case 3:
        return CheckoutSuccessState(currentUser: _currentUser);
      default:
        return ErrorState(error: 'Incorrect Step: $_checkoutProcessStep');
    }
  }

  @override
  Stream<CheckoutState> mapEventToState(
    CheckoutEvent event,
  ) async* {
    yield CheckoutLoadingState();

    if (event is LoadPageEvent) {
      try {
        _currentUser = await locator<AuthService>().getCurrentUser();
        _currentUser.customer = await locator<StripeCustomerService>()
            .retrieve(customerID: _currentUser.customerID);
        _cartItems = await locator<CartItemService>()
            .retrieveCartItems(uid: _currentUser.uid);
        _sku = await locator<StripeSkuService>().retrieve(skuID: SKU_UD);
        _prefs = await SharedPreferences.getInstance();

        yield _getCheckoutState();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is RefreshEvent) {
      _currentUser = await locator<AuthService>().getCurrentUser();
      _currentUser.customer = await locator<StripeCustomerService>()
          .retrieve(customerID: _currentUser.customerID);

      yield _getCheckoutState();
    }

    if (event is NextStepEvent) {
      _checkoutProcessStep += 1;
      yield _getCheckoutState();
    }

    if (event is PreviousStepEvent) {
      _checkoutProcessStep -= 1;
      yield _getCheckoutState();
    }

    if (event is SubmitEvent) {
      try {
        //Create order.
        final String orderID = await locator<StripeOrderService>().create(
          line1: _currentUser.customer!.shipping!.address.line1,
          name: _currentUser.customer!.shipping!.name,
          email: _currentUser.customer!.email,
          city: _currentUser.customer!.shipping!.address.city,
          state: _currentUser.customer!.shipping!.address.state,
          postalCode: _currentUser.customer!.shipping!.address.postalCode,
          country: _currentUser.customer!.shipping!.address.country,
          customerID: _currentUser.customerID,
          sku: _sku,
          cartItems: _cartItems,
        );

        //Pay order.
        await locator<StripeOrderService>().pay(
          orderID: orderID,
          source: _currentUser.customer!.defaultSource!,
          customerID: _currentUser.customerID,
        );

        //Create order document reference.
        DocumentReference ordersDocRef =
            await FirebaseFirestore.instance.collection('orders').add({
          'id': orderID,
          'name': _currentUser.customer!.shipping!.name,
          'email': _currentUser.customer!.email
        });

        //Save cart items to database.
        for (int i = 0; i < _cartItems.length; i++) {
          await ordersDocRef.collection('cartItems').add(
                _cartItems[i].toMap(),
              );
        }

        //Create user cart items reference.
        CollectionReference cartItemsColRef = FirebaseFirestore.instance
            .collection('Users')
            .doc(_currentUser.uid)
            .collection('cartItems');

        //Clear shopping cart.
        List<DocumentSnapshot> docs = (await cartItemsColRef.get()).docs;
        for (int i = 0; i < docs.length; i++) {
          await cartItemsColRef.doc(docs[i].id).delete();
        }

        //Send notification to myself of new order created.
        UserModel admin =
            await locator<UserService>().retrieveUser(uid: ADMIN_DOC_ID);
        await locator<FCMService>().sendNotificationToUser(
          fcmToken: admin.fcmToken!,
          title: 'NEW ORDER',
          body: 'From ${_currentUser.customer!.name}',
        );

        //Proceed to success page.
        add(NextStepEvent());
      } on PlatformException catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
