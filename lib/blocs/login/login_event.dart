part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SubmitEvent extends LoginEvent {
  final String email;
  final String password;

  SubmitEvent({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];
}

class TryAgainEvent extends LoginEvent {
  const TryAgainEvent();

  @override
  List<Object> get props => [];
}
