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

class CheckoutPaymentState extends CheckoutState {
  final UserModel currentUser;

  CheckoutPaymentState({required this.currentUser});

  @override
  List<Object> get props => [
        currentUser,
      ];
}

class CheckoutSubmitState extends CheckoutState {
  final UserModel currentUser;
  final double subTotal;
  final double shippingFee;
  final SkuModel sku;
  final List<CartItemModel> cartItems;
  final double total;

  CheckoutSubmitState({
    required this.currentUser,
    required this.subTotal,
    required this.shippingFee,
    required this.sku,
    required this.cartItems,
    required this.total,
  });

  @override
  List<Object> get props => [
        currentUser,
        subTotal,
        shippingFee,
        sku,
        cartItems,
        total,
      ];
}

class CheckoutSuccessState extends CheckoutState {
  final UserModel currentUser;

  CheckoutSuccessState({required this.currentUser});

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