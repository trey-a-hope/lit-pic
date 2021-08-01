part of 'create_lithophane_bloc.dart';

@immutable
abstract class CreateLithophaneState extends Equatable {}

class CreateLithophaneInitialState extends CreateLithophaneState {
  @override
  List<Object> get props => [];
}

class CreateLithophaneLoadingState extends CreateLithophaneState {
  @override
  List<Object> get props => [];
}

class CreateLithophaneLoadedState extends CreateLithophaneState {
  final SkuModel sku;
  final int quantity;
  final bool imageUploaded;

  CreateLithophaneLoadedState({
    required this.sku,
    required this.quantity,
    required this.imageUploaded,
  });

  @override
  List<Object> get props => [
        sku,
        quantity,
        imageUploaded,
      ];
}

class ErrorState extends CreateLithophaneState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
