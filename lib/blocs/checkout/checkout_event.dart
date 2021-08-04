part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends CheckoutEvent {}

class NextStepEvent extends CheckoutEvent {}

class PreviousStepEvent extends CheckoutEvent {}

class SubmitEvent extends CheckoutEvent {}

class RefreshEvent extends CheckoutEvent {}
