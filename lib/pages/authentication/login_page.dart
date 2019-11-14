import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
          : Stack(
              children: <Widget>[
                Container(
                  color: Colors.green,
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage('Assets/image1.png'),
                  //     fit: BoxFit.fitWidth,
                  //     alignment: Alignment.topCenter
                  //   )
                  // ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 270),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(23),
                      child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: Container(
                                color: Color(0xfff5f5f5),
                                child: TextFormField(
                                  validator: getIt<ValidatorService>().email,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _emailController,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email),
                                      labelStyle: TextStyle(fontSize: 15)),
                                ),
                              ),
                            ),
                            Container(
                              color: Color(0xfff5f5f5),
                              child: TextFormField(
                                validator: getIt<ValidatorService>().password,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                controller: _passwordController,
                                obscureText: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'SFUIDisplay'),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock_outline),
                                    labelStyle: TextStyle(fontSize: 15)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: MaterialButton(
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
                                color: Color(0xffff2d55),
                                elevation: 0,
                                minWidth: 400,
                                height: 50,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(
                                  'Forgot your password?',
                                  style: TextStyle(
                                      fontFamily: 'SFUIDisplay',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Center(
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
                                        )),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                        text: "Sign Up",
                                        style: TextStyle(
                                          fontFamily: 'SFUIDisplay',
                                          color: Color(0xffff2d55),
                                          fontSize: 15,
                                        ))
                                  ]),
                                ),
                              )),
                            )
                          ],
                        ),
                      )),
                )
              ],
            ),
      // body: _isLoading
      //     ? Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : Stack(
      //         children: <Widget>[
      //           // SimpleNavbar(
      //           //   leftWidget: Icon(MdiIcons.arrowLeft),
      //           //   leftTap: () {
      //           //     Navigator.of(context).pop();
      //           //   },
      //           // ),
      //           Center(
      //             child: FractionallySizedBox(
      //               widthFactor: 0.9,
      //               child: Container(
      //                 height: _autoValidate ? 235 : 190,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(8),
      //                   color: Colors.white,
      //                   boxShadow: [
      //                     BoxShadow(
      //                         color: Colors.black12,
      //                         offset: Offset(0, 6),
      //                         blurRadius: 6),
      //                   ],
      //                 ),
      //                 child: Padding(
      //                   padding: EdgeInsets.all(20),
      //                   child: Form(
      //                     key: _formKey,
      //                     autovalidate: _autoValidate,
      //                     child: Column(
      //                       children: <Widget>[
      //                         emailFormField(),
      //                         SizedBox(height: 30),
      //                         passwordFormField(),
      //                         SizedBox(height: 30),
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Align(
      //             alignment: Alignment.bottomCenter,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: <Widget>[
      //                 RaisedButton(
      //                   child: Text('Login'),
      //                   onPressed: () {
      //                     _login();
      //                   },
      //                 ),
      //                 RaisedButton(
      //                   child: Text('Sign Up'),
      //                   onPressed: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => SignUpPage(),
      //                       ),
      //                     );
      //                   },
      //                 )
      //               ],
      //             ),
      //           )
      //         ],
      //       ),
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
      validator: getIt<ValidatorService>().email,
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
      validator: getIt<ValidatorService>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Password',
        icon: Icon(Icons.lock),
        fillColor: Colors.white,
      ),
    );
  }
}
