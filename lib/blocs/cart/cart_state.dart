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
  final SkuModel sku;
  final double subTotal;
  final double shippingFee;
  final double total;

  CartLoadedState({
    required this.cartItems,
    required this.sku,
    required this.subTotal,
    required this.shippingFee,
    required this.total,
  });

  @override
  List<Object> get props => [
        cartItems,
        sku,
        subTotal,
        shippingFee,
        total,
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
