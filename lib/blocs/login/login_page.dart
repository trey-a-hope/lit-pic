part of 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final double _containerHeight = 350.0;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: BlocConsumer<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoadingState) {
            return Spinner();
          }

          if (state is LoginInitialState) {
            return ListView(
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
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Color(0xfff5f5f5),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: locator<ValidatorService>().email,
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
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Color(0xfff5f5f5),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator:
                                      locator<ValidatorService>().password,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
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
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GoodButton(
                                textColor: Colors.white,
                                buttonColor: Colors.amber[700]!,
                                onPressed: () {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  context.read<LoginBloc>().add(
                                        SubmitEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
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
                                    text: TextSpan(
                                      children: [
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
                                      ],
                                    ),
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
            );
          }

          if (state is ErrorState) {
            final String errorMessage =
                state.error.message ?? 'Could not log in at this time.';
            return Stack(
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
                    child: Column(
                      children: [
                        Text('$errorMessage', textAlign: TextAlign.center),
                        Spacer(),
                        GoodButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(TryAgainEvent());
                          },
                          text: 'Try Again',
                          buttonColor: Colors.orange,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }

          return Container();
        },
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Phoenix.rebirth(context);
          }
        },
      ),
    );
  }
}
