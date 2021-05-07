part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class LoadPageEvent extends SignupEvent {}

class SubmitEvent extends SignupEvent {
  final String name;
  final String email;
  final String password;

  SubmitEvent({
    @required this.name,
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [
        name,
        email,
        password,
      ];
}
