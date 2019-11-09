import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/asset_images.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/models/stripe/customer.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/card.dart';
import 'package:litpic/services/stripe/token.dart';
import 'package:litpic/services/validater_service.dart';

class AddCreditCardPage extends StatefulWidget {
  AddCreditCardPage({@required this.customer});
  final Customer customer;
  @override
  State createState() => AddCreditCardPageState(this.customer);
}

class AddCreditCardPageState extends State<AddCreditCardPage> {
  AddCreditCardPageState(this._customer);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _autoValidate = false;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final Customer _customer;
  final GetIt getIt = GetIt.I;

  @override
  void initState() {
    super.initState();
  }

  void _addTestCardInfo() {
    _cardNumberController.text = '4242424242424242';
    _expirationController.text = '0621';
    _cvcController.text = '323';
    _autoValidate = true;
  }

  void _clearForm() {
    _cardNumberController.clear();
    _expirationController.clear();
    _cvcController.clear();
  }

  void _submitCard() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      bool confirm = await getIt<ModalService>().showConfirmation(
          context: context,
          title: 'Add Card',
          message: 'This will become your default card on file. Proceed?');
      if (confirm) {
        setState(
          () {
            _isLoading = true;
          },
        );

        String number = _cardNumberController.text;
        String expMonth = _expirationController.text.substring(0, 2);
        String expYear = _expirationController.text.substring(2, 4);
        String cvc = _cvcController.text;

        try {
          String token = await getIt<StripeToken>().create(
              number: number,
              expMonth: expMonth,
              expYear: expYear,
              cvc: cvc);

              await getIt<StripeCard>().create(customerID: _customer.id, token: token);

          print(token);

          setState(
            () {
              _isLoading = false;
            },
          );
          getIt<ModalService>().showAlert(
              context: context, title: 'Success', message: 'Card added successfully.');
        } catch (e) {
          setState(
            () {
              _isLoading = false;
            },
          );
          getIt<ModalService>().showAlert(
              context: context,
              title: 'Error',
              message: 'Could not save card at this time.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Credit Card'),
      ),
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _isLoading
            ? Spinner()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: creditCard2,
                        height: 250.0,
                      ),
                      //Card Number
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _cardNumberController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              onFieldSubmitted: (term) {},
                              validator: getIt<ValidatorService>().cardNumber,
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                hintText: 'Card Number',
                                icon: Icon(Icons.credit_card,
                                    color: Theme.of(context)
                                        .primaryIconTheme
                                        .color),
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //Expiration
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _expirationController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              onFieldSubmitted: (term) {},
                              validator: getIt<ValidatorService>().cardExpiration,
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                hintText: 'Expiration',
                                icon: Icon(Icons.date_range,
                                    color: Theme.of(context)
                                        .primaryIconTheme
                                        .color),
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      //CVC
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _cvcController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              onFieldSubmitted: (term) {},
                              validator: getIt<ValidatorService>().cardCVC,
                              onSaved: (value) {},
                              decoration: InputDecoration(
                                hintText: 'CVC',
                                icon: Icon(Icons.security,
                                    color: Theme.of(context)
                                        .primaryIconTheme
                                        .color),
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              color: Theme.of(context).buttonColor,
                              child: Text('Add Test',
                                  style:
                                      Theme.of(context).accentTextTheme.button),
                              onPressed: () {
                                _addTestCardInfo();
                              },
                            ),
                            RaisedButton(
                              color: Theme.of(context).buttonColor,
                              child: Text('Add Card',
                                  style:
                                      Theme.of(context).accentTextTheme.button),
                              onPressed: () {
                                _submitCard();
                              },
                            ),
                            RaisedButton(
                              color: Theme.of(context).buttonColor,
                              child: Text('Clear',
                                  style:
                                      Theme.of(context).accentTextTheme.button),
                              onPressed: () {
                                _clearForm();
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
