import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/common/lit_pic_app_bar.dart';
import 'package:litpic/common/lit_pic_list_views.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/mixins/ui_properties_mixin.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/views/data_box_view.dart';
import 'package:litpic/views/pay_flow_diagram_view.dart';
import 'package:litpic/views/round_button_view.dart';
import 'package:litpic/views/title_view.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_page.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial());

  late UserModel _currentUser;
  // SkuModel _sku;
  // List<CartItemModel> _cartItems;
  // double _shippingFee = 0.0;

  int _checkoutProcessStep = 0;

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

        switch (_checkoutProcessStep) {
          case 0:
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // double subTotal = prefs.getDouble('subTotal');

            yield CheckoutShippingState(currentUser: _currentUser);
            break;

          default:
            yield ErrorState(error: 'Incorrect Step: $_checkoutProcessStep');
            break;
        }
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
