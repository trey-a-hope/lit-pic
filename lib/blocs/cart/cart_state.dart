part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItemModel> cartItems;
  final double subTotal;
  final double shippingFee;
  final double total;
  final PriceModel price;
  final UserModel currentUser;

  CartLoadedState({
    required this.cartItems,
    required this.subTotal,
    required this.shippingFee,
    required this.total,
    required this.price,
    required this.currentUser,
  });

  @override
  List<Object> get props => [
        cartItems,
        subTotal,
        shippingFee,
        total,
        price,
        currentUser,
      ];
}

class ErrorState extends CartState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}

class StripeCheckoutState extends CartState {
  final SessionModel session;

  StripeCheckoutState({
    required this.session,
  });

  @override
  List<Object> get props => [
        session,
      ];
}
