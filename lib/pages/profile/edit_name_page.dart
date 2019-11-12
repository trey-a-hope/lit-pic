
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditNamePage extends StatefulWidget {
  @override
  State createState() => EditNamePageState();
}

class EditNamePageState extends State<EditNamePage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  TextEditingController _nameController = TextEditingController();

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

      _nameController.text = _currentUser.customer.name;

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

          //Update name.
          await getIt<StripeCustomer>().updateName(
              customerID: _currentUser.customerID,
              name: _nameController.text);

          setState(
            () {
              _isLoading = false;
            },
          );
          getIt<ModalService>().showAlert(
            context: context,
            title: 'Success',
            message: 'Name Updated',
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
        title: Text('Edit Name'),
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
                _nameFormField(),
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

  Widget _nameFormField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<ValidatorService>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Name',
        icon: Icon(MdiIcons.face),
        fillColor: Colors.white,
      ),
    );
  }

}
