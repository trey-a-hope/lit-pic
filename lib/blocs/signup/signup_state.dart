part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupLoadedState extends SignupState {
  final bool signupSuccessful;
  SignupLoadedState({@required this.signupSuccessful});

  @override
  List<Object> get props => [
        signupSuccessful,
      ];
}

class ErrorState extends SignupState {
  final dynamic error;

  ErrorState({
    @required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
