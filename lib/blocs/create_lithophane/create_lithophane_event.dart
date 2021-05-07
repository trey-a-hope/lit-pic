part of 'create_lithophane_bloc.dart';

@immutable
abstract class CreateLithophaneEvent {}

class LoadPageEvent extends CreateLithophaneEvent {}

class UpdateQuantityEvent extends CreateLithophaneEvent {
  final int quantity;

  UpdateQuantityEvent({
    @required this.quantity,
  });

  @override
  List<Object> get props => [
        quantity,
      ];
}

class AddToCartEvent extends CreateLithophaneEvent {
  final PickedFile image;

  AddToCartEvent({
    @required this.image,
  });

  @override
  List<Object> get props => [
        image,
      ];
}
