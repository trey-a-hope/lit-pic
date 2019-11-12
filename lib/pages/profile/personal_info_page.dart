
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/pages/profile/edit_address_page.dart';
import 'package:litpic/pages/profile/edit_email_page.dart';
import 'package:litpic/pages/profile/edit_name_page.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  State createState() => PersonalInfoPageState();
}

class PersonalInfoPageState extends State<PersonalInfoPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  _load() async {
    try {
      _currentUser = await getIt<AuthService>().getCurrentUser();
      _currentUser.customer = await getIt<StripeCustomer>()
          .retrieve(customerID: _currentUser.customerID);
      print(_currentUser.customer.email);
      setState(
        () {
          _isLoading = false;
        },
      );
    } catch (e) {
      getIt<ModalService>().showAlert(
        context: context,
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _load(),
          )
        ],
      ),
      body: _isLoading
          ? Spinner()
          : Column(
              children: <Widget>[
                //Name
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Name'),
                            RaisedButton(
                              child: Text('Update Name'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditNamePage(),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        Text(_currentUser.customer.name),
                      ],
                    ),
                  ),
                ),
                //Email
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Email'),
                            RaisedButton(
                              child: Text('Update Email'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditEmailPage(),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        Text(_currentUser.customer.email),
                      ],
                    ),
                  ),
                ),
                //Shipping Info
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    child: _currentUser.customer.address == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Shipping Info'),
                              RaisedButton(
                                child: Text('Update Shipping Info'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAddressPage(),
                                    ),
                                  );
                                },
                              )
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Shipping Info'),
                                  RaisedButton(
                                    child: Text('Update Shipping Info'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditAddressPage(),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                              Text('Address'),
                              Text(_currentUser.customer.address.line1),
                              Text('City'),
                              Text(_currentUser.customer.address.city),
                              Text('State'),
                              Text(_currentUser.customer.address.state),
                              Text('ZIP'),
                              Text(_currentUser.customer.address.postalCode),
                            ],
                          ),
                  ),
                )
              ],
            ),
    );
  }
}
