part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadPageEvent extends CartEvent {}

class IncrementQuantityEvent extends CartEvent {
  final CartItemModel cartItem;

  const IncrementQuantityEvent({@required this.cartItem});

  @override
  List<Object> get props => [
        cartItem,
      ];
}

class DecrementQuantityEvent extends CartEvent {
  final CartItemModel cartItem;

  const DecrementQuantityEvent({@required this.cartItem});

  @override
  List<Object> get props => [
        cartItem,
      ];
}

class DeleteCartItemEvent extends CartEvent {
  final CartItemModel cartItem;

  const DeleteCartItemEvent({@required this.cartItem});

  @override
  List<Object> get props => [cartItem];
}

class RefreshEvent extends CartEvent {
  const RefreshEvent();

  @override
  List<Object> get props => [];
}
