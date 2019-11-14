import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/asset_images.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/pages/authentication/sign_up_page.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/common/simple_navbar.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool _isLoading = false;
  final GetIt getIt = GetIt.I;
  final double _containerHeight = 300.0;

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        setState(
          () {
            _isLoading = true;
          },
        );
        await getIt<AuthService>().signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        // Navigator.pop(context);
      } catch (e) {
        setState(
          () {
            _isLoading = false;
          },
        );
        getIt<ModalService>().showAlert(
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
                          // color: Colors.green,
                          decoration: BoxDecoration(
                            
                            image: DecorationImage(
                              image: loginImage,
                              fit: BoxFit.cover,
                              // alignment: Alignment.topCenter
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 50,
                          right: 23,
                          child: Text(
                            'Light Up',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                              MaterialButton(
                                onPressed: () {
                                  _login();
                                }, //since this is only a UI app
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'SFUIDisplay',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                color: Colors.amber[700],
                                elevation: 0,
                                minWidth: 400,
                                height: 50,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    getIt<ModalService>().showAlert(
                                        context: context,
                                        title: 'Forgot Password',
                                        message: 'Todo');
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage(),
                                      ),
                                    );
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
      validator: getIt<ValidatorService>().email,
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
      validator: getIt<ValidatorService>().password,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock_outline),
          labelStyle: TextStyle(fontSize: 15)),
    );
  }
}
