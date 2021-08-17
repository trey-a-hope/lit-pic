part of 'add_lit_pic_bloc.dart';

@immutable
abstract class AddLitPicState extends Equatable {
  const AddLitPicState();

  @override
  List<Object> get props => [];
}

class AddLitPicInitial extends AddLitPicState {}

class AddLitPicLoadingState extends AddLitPicState {
  @override
  List<Object> get props => [];
}

class AddLitPicLoadedState extends AddLitPicState {
  AddLitPicLoadedState();

  @override
  List<Object> get props => [];
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
