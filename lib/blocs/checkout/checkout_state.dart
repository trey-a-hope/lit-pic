part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

// class CheckoutInitial extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {
  @override
  List<Object> get props => [];
}

class CheckoutShippingState extends CheckoutState {
  CheckoutShippingState();

  @override
  List<Object> get props => [];
}

class ErrorState extends CheckoutState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
