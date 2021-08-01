part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {
  @override
  List<Object> get props => [];
}

class CheckoutLoadedState extends CheckoutState {
  CheckoutLoadedState();

  @override
  List<Object> get props => [];
}

class CheckoutShippingState extends CheckoutState {
  final UserModel currentUser;
   
  CheckoutShippingState({required this.currentUser});

  @override
  List<Object> get props => [
        currentUser,
      ];
}

class ErrorState extends CheckoutState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
