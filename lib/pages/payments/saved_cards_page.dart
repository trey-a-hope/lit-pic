import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/constants.dart';
import 'package:litpic/models/stripe/credit_card.dart';
import 'package:litpic/pages/payments/add_credit_card_page.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/stripe/card.dart';
import 'package:litpic/services/stripe/customer.dart';

class SavedCardsPage extends StatefulWidget {
  @override
  State createState() => SavedCardsPageState();
}

class SavedCardsPageState extends State<SavedCardsPage> {
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

  void _deleteCard({@required CreditCard creditCard}) async {
    bool confirm = await getIt<ModalService>().showConfirmation(
        context: context,
        title: 'Delete Card - ${creditCard.last4}',
        message: 'Are you sure?');
    if (confirm) {
      try {
        setState(() {
          _isLoading = true;
        });
        getIt<StripeCard>()
            .delete(customerID: _currentUser.customerID, cardID: creditCard.id);

        _load();
      } catch (e) {
        getIt<ModalService>().showAlert(
          context: context,
          title: 'Error',
          message: e.toString(),
        );
      }
    }
  }

  void _makeDefault({@required CreditCard creditCard}) async {
    if (_currentUser.customer.defaultSource == creditCard.id) {
      return;
    }
    bool confirm = await getIt<ModalService>().showConfirmation(
        context: context,
        title: 'Make Default Card - ${creditCard.last4}',
        message: 'Are you sure?');
    if (confirm) {
      try {
        setState(() {
          _isLoading = true;
        });

        getIt<StripeCustomer>().updateDefaultSource(
            customerID: _currentUser.customerID, defaultSource: creditCard.id);

        _load();
      } catch (e) {
        getIt<ModalService>().showAlert(
          context: context,
          title: 'Error',
          message: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Saved Cards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddCreditCardPage(customer: _currentUser.customer),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _load();
            },
          )
        ],
      ),
      body: _isLoading
          ? Spinner()
          : _currentUser.customer.sources.isEmpty
              ? Center(
                  child: Text('No Saved Cards'),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCreditCard(
                        creditCard: _currentUser.customer.sources[index]);
                  },
                  itemCount: _currentUser.customer.sources.length,
                ),
    );
  }

  _buildCreditCard({@required CreditCard creditCard}) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 3,
        child: ListTile(
          onTap: () => _makeDefault(creditCard: creditCard),
          leading: Icon(Icons.credit_card,
              color: _currentUser.customer.defaultSource == creditCard.id
                  ? Colors.green
                  : Colors.black),
          title:
              Text('${creditCard.brand} / ****-****-****-${creditCard.last4}'),
          subtitle: Text('Expires ' +
              months[creditCard.expMonth] +
              ' ' +
              '${creditCard.expYear}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteCard(creditCard: creditCard),
          ),
        ),
      ),
    );
  }
}
