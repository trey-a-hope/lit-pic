import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/good_button.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/litpic_theme.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/pages/data_box_view.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:litpic/titleView.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditBasicInfoPage extends StatefulWidget {
  const EditBasicInfoPage({Key key}) : super(key: key);
  @override
  _EditBasicInfoPageState createState() => _EditBasicInfoPageState();
}

class _EditBasicInfoPageState extends State<EditBasicInfoPage>
    with TickerProviderStateMixin {
  AnimationController animationController;

  Animation<double> topBarAnimation;

  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final GetIt getIt = GetIt.I;
  final Color iconColor = Colors.amber[700];

  User _currentUser;

  bool addAllListDataComplete = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  bool _isLoading = false;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    if (!addAllListDataComplete) {
      addAllListDataComplete = true;
      var count = 5;

      listViews.add(
        _isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.blue[200],
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              )
            : SizedBox.shrink(),
      );

      listViews.add(
        Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: nameFormField(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: emailFormField(),
              ),
            ],
          ),
        ),
      );

      listViews.add(
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: GoodButton(
            buttonColor: Colors.amber,
            textColor: Colors.white,
            onPressed: _save,
            text: 'SAVE',
          ),
        ),
      );
    }
  }

  Future<void> loadCustomerInfo() async {
    try {
      //Load user.
      _currentUser = await getIt<AuthService>().getCurrentUser();
      _currentUser.customer = await getIt<StripeCustomer>()
          .retrieve(customerID: _currentUser.customerID);

      _nameController.text = _currentUser.customer.name;
      _emailController.text = _currentUser.customer.email;

      return;
    } catch (e) {
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
      return;
    }
  }

  _save() async {
    if (_formKey.currentState.validate()) {
      bool confirm = await getIt<ModalService>().showConfirmation(
          context: context, title: 'Submit', message: 'Are you sure?');

      if (confirm) {
        _formKey.currentState.save();
        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          final String updatedEmail = _emailController.text;
          final String updatedName = _nameController.text;

          //Attempt to update email first.
          await getIt<AuthService>().updateEmail(email: updatedEmail);

          //Update email.
          await getIt<StripeCustomer>().updateEmail(
              customerID: _currentUser.customerID, email: updatedEmail);

          //Update name.
          await getIt<StripeCustomer>().updateName(
              customerID: _currentUser.customerID, name: updatedName);

          setState(
            () {
              _isLoading = false;
            },
          );
          
          getIt<ModalService>().showAlert(
            context: context,
            title: 'Success',
            message: 'Basic Info Updated',
          );
        } catch (e) {
          setState(
            () {
              _isLoading = false;
            },
          );
          getIt<ModalService>().showAlert(
            context: context,
            title: 'Error',
            message: e.toString(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LitPicTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    List<Future> futures = List<Future>();
    futures.add(loadCustomerInfo());
    return FutureBuilder(
      future: Future.wait(futures),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Spinner();
        } else {
          addAllListData();
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: LitPicTheme.white.withOpacity(topBarOpacity),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color:
                              LitPicTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(MdiIcons.chevronLeft),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Edit Basic Info',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: LitPicTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: LitPicTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget nameFormField() {
    return TextFormField(
      validator: getIt<ValidatorService>().isEmpty,
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
}
