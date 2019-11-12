import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:litpic/services/validater_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditAddressPage extends StatefulWidget {
  @override
  State createState() => EditAddressPageState();
}

class EditAddressPageState extends State<EditAddressPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  TextEditingController _addressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String _stateController;
  String selectedState;
  TextEditingController _zipController = TextEditingController();

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

      if (_currentUser.customer.address != null) {
        _addressController.text = _currentUser.customer.address.line1;
        _cityController.text = _currentUser.customer.address.city;
        selectedState = _currentUser.customer.address.state;
        _zipController.text = _currentUser.customer.address.postalCode;
      }

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

          //Update address info.
          await getIt<StripeCustomer>().updateAddress(
              customerID: _currentUser.customerID,
              line1: _addressController.text,
              city: _cityController.text,
              state: selectedState,
              postalCode: _zipController.text,
              country: 'USA');

          setState(
            () {
              _isLoading = false;
            },
          );
          getIt<ModalService>().showAlert(
            context: context,
            title: 'Success',
            message: 'Shipping Info Updated',
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
        title: Text('Edit Shipping Info'),
      ),
      body: Column(
        children: <Widget>[
          _isLoading
              ? LinearProgressIndicator(
                  backgroundColor: Colors.blue[200],
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                )
              : Container(),
          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                _addressFormField(),
                SizedBox(height: 20),
                _cityFormField(),
                SizedBox(height: 20),
                _stateFormField(),
                SizedBox(height: 20),
                _zipFormField(),
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

  Widget _addressFormField() {
    return TextFormField(
      controller: _addressController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<ValidatorService>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'Address',
        icon: Icon(MdiIcons.home),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _cityFormField() {
    return TextFormField(
      controller: _cityController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<ValidatorService>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'City',
        icon: Icon(MdiIcons.city),
        fillColor: Colors.white,
      ),
    );
  }

  Widget _stateFormField() {
    return DropdownButton<String>(
        hint: Text('State'),
        items: unitedStates.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        value: selectedState,
        onChanged: (String newValue) {
          setState(() {
            selectedState = newValue;
          });
        });
  }

  Widget _zipFormField() {
    return TextFormField(
      controller: _zipController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLengthEnforced: true,
      // maxLength: MyFormData.nameCharLimit,
      onFieldSubmitted: (term) {},
      validator: getIt<ValidatorService>().isEmpty,
      onSaved: (value) {},
      decoration: InputDecoration(
        hintText: 'ZIP',
        icon: Icon(MdiIcons.zipBox),
        fillColor: Colors.white,
      ),
    );
  }
}
