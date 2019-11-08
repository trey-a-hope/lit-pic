import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/image_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditEmailPage extends StatefulWidget {
  @override
  State createState() => EditEmailPageState();
}

class EditEmailPageState extends State<EditEmailPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

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

        _emailController.text = _currentUser.customer.email;
      

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

  _save() async {
    bool confirm = await getIt<ModalService>().showConfirmation(
        context: context, title: 'Submit', message: 'Are you sure?');

    if (confirm) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        try {
          setState(
            () {
              _isLoading = true;
            },
          );

          //Update email in Auth.
          await getIt<AuthService>().updateEmail(email: _emailController.text);

          //Update email in Stripe.
          await getIt<StripeCustomer>().updateEmail(
              customerID: _currentUser.customerID,
              email: _emailController.text);

          setState(
            () {
              _isLoading = false;
            },
          );
          getIt<ModalService>().showAlert(
            context: context,
            title: 'Success',
            message: 'Email Updated',
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Email'),
      ),
      body: Column(
        children: <Widget>[
          _isLoading
              ? LinearProgressIndicator(
                  backgroundColor: Colors.blue[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                )
              : SizedBox.shrink(),
          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                _emailFormField(),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () => _save(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _emailFormField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<ValidatorService>().email,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Email',
        icon: Icon(MdiIcons.email),
        fillColor: Colors.white,
      ),
    );
  }

}
