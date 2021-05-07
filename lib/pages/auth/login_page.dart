import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:litpic/asset_images.dart';
import 'package:litpic/blocs/signup/signup_bloc.dart';
import 'package:litpic/blocs/signup/signup_page.dart';
import 'package:litpic/common/good_button.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/pages/auth/password_reset_page.dart';
import 'package:litpic/service_locator.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/validater_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  final double _containerHeight = 350.0;

  bool _obscureText = true;

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        setState(
          () {
            _isLoading = true;
          },
        );
        await locator<AuthService>().signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        // Navigator.pop(context);
      } catch (e) {
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
    } else {
      setState(
        () {
          _autoValidate = true;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
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
                          autovalidate: _autoValidate,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
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
                                  _login();
                                },
                                text: 'SIGN IN',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PasswordResetPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot your password?',
                                    style: TextStyle(
                                        fontFamily: 'SFUIDisplay',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) =>
                                            SignupBloc()..add(LoadPageEvent()),
                                        child: SignupPage(),
                                      ),
                                    );
                                    Navigator.push(context, route);
                                  },
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: "Don't have an account?",
                                        style: TextStyle(
                                          fontFamily: 'SFUIDisplay',
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      TextSpan(text: ' '),
                                      TextSpan(
                                        text: "Sign Up",
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
        labelStyle: TextStyle(fontSize: 15),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye_sharp),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
