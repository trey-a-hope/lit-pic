import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/simple_navbar.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/auth.dart';
import 'package:litpic/services/db.dart';
import 'package:litpic/services/modal.dart';
import 'package:litpic/services/validater.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  State createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();
  }

  _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool confirm = await getIt<Modal>().showConfirmation(
          context: context, title: 'Submit', message: 'Are you ready?');
      if (confirm) {
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          //Create new user in auth.
          AuthResult authResult =
              await getIt<Auth>().createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          final FirebaseUser firebaseUser = authResult.user;

          User user = User(
            id: null,
            imgUrl: null,
            isAdmin: false,
            email: firebaseUser.email,
            fcmToken: null,
            time: DateTime.now(),
            uid: firebaseUser.uid,
            username: _firstNameController.text,
          );

          await getIt<DB>().createUser(user: user);

          Navigator.of(context).pop();
        } catch (e) {
          setState(
            () {
              getIt<Modal>().showAlert(
                context: context,
                title: 'Error',
                message: e.message(),
              );
            },
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
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                SimpleNavbar(
                  leftWidget: Icon(MdiIcons.arrowLeft),
                  leftTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Container(
                      height: _autoValidate ? 405 : 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 6),
                              blurRadius: 6),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: Column(
                            children: <Widget>[
                              firstNameFormField(),
                              SizedBox(height: 30),
                              lastNameFormField(),
                              SizedBox(height: 30),
                              emailFormField(),
                              SizedBox(height: 30),
                              passwordFormField(),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    child: Text('Sign Up'),
                    onPressed: () {
                      _signUp();
                    },
                  ),
                )
              ],
            ),
    );
  }

  Widget firstNameFormField() {
    return TextFormField(
      controller: _firstNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'First Name',
        icon: Icon(Icons.face),
        fillColor: Colors.white,
      ),
    );
  }


  Widget lastNameFormField() {
    return TextFormField(
      controller: _lastNameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Last Name',
        icon: Icon(Icons.face),
        fillColor: Colors.white,
      ),
    );
  }

  Widget emailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().email,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Email',
        icon: Icon(Icons.email),
        fillColor: Colors.white,
      ),
    );
  }

  Widget passwordFormField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      obscureText: true,
      onFieldSubmitted: (term) {},
      validator: getIt<Validator>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Password',
        icon: Icon(Icons.lock),
        fillColor: Colors.white,
      ),
    );
  }
}
