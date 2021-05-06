import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/asset_images.dart';
import 'package:litpic/common/good_button.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/models/user_model.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe_customer_service.dart';
import 'package:litpic/services/user_service.dart';
import 'package:litpic/services/validater_service.dart';

import '../../service_locator.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  final double _containerHeight = 350.0;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await locator<ModalService>().showConfirmation(
          context: context,
          title: 'Submit',
          message: 'Create my account with the following information.');
      if (confirm) {
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          //Create customer in Stripe.
          String customerID = await locator<StripeCustomerService>().create(
            email: _emailController.text,
            name: _nameController.text,
            description: '',
          );

          //Create user in Auth.
          AuthResult authResult =
              await locator<AuthService>().createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          //Create user in Database.
          final FirebaseUser firebaseUser = authResult.user;
          UserModel user = UserModel(
            uid: firebaseUser.uid,
            fcmToken: null,
            created: DateTime.now(),
            modified: DateTime.now(),
            customerID: customerID,
          );
          await locator<UserService>().createUser(user: user);

          Navigator.of(context).pop();
        } on PlatformException catch (e) {
          setState(
            () {
              _isLoading = false;
            },
          );
          locator<ModalService>().showAlert(
            context: context,
            title: 'Error',
            message: e.message,
          );
        }
      }
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: _isLoading
          ? Spinner()
          : ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: _containerHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: loginImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 60,
                          right: 23,
                          child: Text(
                            'Lit Pic',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Positioned(
                          bottom: 40,
                          right: 23,
                          child: Text(
                            'Light up every moment.',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: _containerHeight - 30),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(23),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Color(0xfff5f5f5),
                                child: nameFormField(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Color(0xfff5f5f5),
                                child: emailFormField(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Color(0xfff5f5f5),
                                child: passwordFormField(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GoodButton(
                                textColor: Colors.white,
                                buttonColor: Colors.amber[700],
                                onPressed: () {
                                  _signUp();
                                },
                                text: 'SIGN UP',
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              //   Padding(
                              //   padding: EdgeInsets.only(top: 30),
                              //   child: Center(
                              //       child: InkWell(
                              //     onTap: () {
                              //       Navigator.of(context).pop();
                              //     },
                              //     child: RichText(
                              //       text: TextSpan(children: [
                              //         TextSpan(
                              //             text: "Already have an account?",
                              //             style: TextStyle(
                              //               fontFamily: 'SFUIDisplay',
                              //               color: Colors.black,
                              //               fontSize: 15,
                              //             )),
                              //         TextSpan(text: ' '),
                              //         TextSpan(
                              //             text: "Sign In",
                              //             style: TextStyle(
                              //               fontFamily: 'SFUIDisplay',
                              //               color: Color(0xffff2d55),
                              //               fontSize: 15,
                              //             ))
                              //       ]),
                              //     ),
                              //   )),
                              // )
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: "Already have an account?",
                                        style: TextStyle(
                                          fontFamily: 'SFUIDisplay',
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(text: ' '),
                                      TextSpan(
                                        text: "Sign In",
                                        style: TextStyle(
                                          fontFamily: 'SFUIDisplay',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber[700],
                                          fontSize: 15,
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }

  Widget nameFormField() {
    return TextFormField(
      validator: locator<ValidatorService>().isEmpty,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _nameController,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name',
          prefixIcon: Icon(Icons.face),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget emailFormField() {
    return TextFormField(
      validator: locator<ValidatorService>().email,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _emailController,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          prefixIcon: Icon(Icons.email),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      validator: locator<ValidatorService>().password,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      obscureText: _obscureText,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye_sharp),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }
}
