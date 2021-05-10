import 'dart:async';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:litpic/asset_images.dart';
import 'package:litpic/blocs/signup/signup_bloc.dart';
import 'package:litpic/blocs/signup/signup_page.dart';
import 'package:litpic/common/good_button.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/pages/auth/password_reset_page.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_page.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is SubmitEvent) {
      yield LoginLoadingState();

      final String email = event.email;
      final String password = event.password;
      try {
        await locator<AuthService>().signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        yield LoginSuccessState();
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is TryAgainEvent) {
      yield LoginInitialState();
    }
  }
}
