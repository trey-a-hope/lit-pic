part of 'add_lit_pic_bloc.dart';

abstract class AddLitPicState extends Equatable {
  const AddLitPicState();

  @override
  List<Object> get props => [];
}

class AddLitPicInitial extends AddLitPicState {}

class AddLitPicLoadingState extends AddLitPicState {}

class AddLitPicLoadedState extends AddLitPicState {}

class SuccessState extends AddLitPicState {
  final String litPicId;

  SuccessState({
    required this.litPicId,
  });

  @override
  List<Object> get props => [
        litPicId,
      ];
}

class ErrorState extends AddLitPicState {
  final dynamic error;

  ErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
