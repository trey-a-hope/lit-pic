import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();

    getIt<AuthService>().onAuthStateChanged().listen(
      (firebaseUser) {
        setState(
          () {
            _isLoggedIn = firebaseUser != null;
            if (_isLoggedIn) {
              _load();
            } else {
              _isLoading = false;
            }
          },
        );
      },
    );
  }

  _load() async {
    try {
      _currentUser = await getIt<AuthService>().getCurrentUser();
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
    return _isLoading
        ? Spinner()
        : _isLoggedIn ? isLoggedInView() : LoggedOutView();
  }

  Widget isLoggedInView() {
    return ListView(
      children: <Widget>[_deleteAccount(), Divider(), _signOut(), Divider()],
    );
  }

  ListTile _deleteAccount() {
    return ListTile(
      leading: Icon(
        MdiIcons.delete,
        color: Colors.white,
      ),
      title: Text(
        'Delete Account',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Remove account from this app.',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        bool confirm = await getIt<ModalService>().showConfirmation(
            context: context,
            title: 'Delete Account',
            message: 'Are you sure?');
        if (confirm) {
          try {
            await getIt<AuthService>().deleteUser(userID: _currentUser.id);
            Navigator.popUntil(
              context,
              ModalRoute.withName(Navigator.defaultRouteName),
            );
          } catch (e) {
            getIt<ModalService>().showAlert(
              context: context,
              title: 'Error',
              message: e.toString(),
            );
          }
        }
      },
    );
  }

  ListTile _signOut() {
    return ListTile(
      leading: Icon(
        MdiIcons.logout,
        color: Colors.white,
      ),
      title: Text(
        'Sign Out',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Log out temporarily.',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        bool confirm = await getIt<ModalService>().showConfirmation(
            context: context, title: 'Sign Out', message: 'Are you sure?');
        if (confirm) {
          await getIt<AuthService>().signOut();
        }
      },
    );
  }
}
