import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/services/user_service.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitialState());

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    yield SignupLoadingState();

    if (event is LoadPageEvent) {
      try {
        yield SignupLoadedState(signupSuccessful: false);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }

    if (event is SubmitEvent) {
      final String name = event.name;
      final String email = event.email;
      final String password = event.password;

      try {
        //Create customer in Stripe.
        String customerID = await locator<StripeCustomerService>().create(
          email: email,
          name: name,
          description: 'I\'ve been a member since ${DateTime.now()}',
        );

        //Create user in Auth.
        UserCredential userCredential =
            await locator<AuthService>().createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //Create user in Database.
        UserModel user = UserModel(
          uid: userCredential.user!.uid,
          fcmToken: null,
          created: DateTime.now(),
          modified: DateTime.now(),
          customerID: customerID,
        );

        await locator<UserService>().createUser(user: user);

        yield SignupLoadedState(signupSuccessful: true);
      } catch (error) {
        yield ErrorState(error: error);
      }
    }
  }
}
