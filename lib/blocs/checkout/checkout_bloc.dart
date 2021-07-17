import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_page.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(CheckoutInitial());

  @override
  Stream<CheckoutState> mapEventToState(
    CheckoutEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
