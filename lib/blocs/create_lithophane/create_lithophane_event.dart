part of 'create_lithophane_bloc.dart';

abstract class CreateLithophaneEvent extends Equatable {}

class LoadPageEvent extends CreateLithophaneEvent {
  @override
  List<Object> get props => [];
}

class UpdateQuantityEvent extends CreateLithophaneEvent {
  final int quantity;

  UpdateQuantityEvent({
    required this.quantity,
  });

  @override
  List<Object> get props => [
        quantity,
      ];
}

class AddToCartEvent extends CreateLithophaneEvent {
  final XFile image;

  AddToCartEvent({
    required this.image,
  });

  @override
  List<Object> get props => [
        image,
      ];
}
