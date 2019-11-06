import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:litpic/common/logged_out_view.dart';
import 'package:litpic/common/spinner.dart';
import 'package:litpic/services/auth_service.dart';
import 'package:litpic/models/database/user.dart';
import 'package:litpic/services/db_service.dart';
import 'package:litpic/services/modal_service.dart';
import 'package:litpic/services/storage_service.dart';
import 'package:litpic/services/stripe/customer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final GetIt getIt = GetIt.I;
  User _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // getIt<AuthService>().onAuthStateChanged().listen(
    //   (firebaseUser) {
    //     setState(
    //       () {
    //         _isLoggedIn = firebaseUser != null;
    //         if (_isLoggedIn) {
    //           _load();
    //         } else {
    //           _isLoading = false;
    //         }
    //       },
    //     );
    //   },
    // );

    _load();
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
        : ListView(
            children: <Widget>[
              
              _about(),
              Divider(),
              _faqs(),
              Divider(),
              _helpSupport(),
              Divider(),
              _deleteAccount(),
              Divider(),
              _signOut(),
              Divider()
            ],
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
        getIt<ModalService>().showAlert(
            context: context,
            title: 'Delete Account',
            message:
                'Contact tr3umphant.designs@gmail.com to remove your account. Thank you.');

        // bool confirm = await getIt<ModalService>().showConfirmation(
        //     context: context,
        //     title: 'Delete Account',
        //     message: 'Are you sure?');
        // if (confirm) {
        //   try {
        //     //Delete user from Stripe.
        //     await getIt<StripeCustomer>()
        //         .delete(customerID: _currentUser.customerID);
        //     //Delete user from Database.
        //     await getIt<DBService>().deleteUser(id: _currentUser.id);
        //     //Delete user from Auth, (last because of security rules).
        //     await getIt<AuthService>().deleteUser(userID: _currentUser.id);

        //     The problem with this solution is;

        //     1. Deleting from DB first; Auth may not delete because it requires fresh login or some bullshit.
        //     2. Deleting from Auth first; DB won't delete because of security rules.

        //     Thus, I'm holding off on this for now.

        //     Navigator.popUntil(
        //       context,
        //       ModalRoute.withName(Navigator.defaultRouteName),
        //     );
        //   } catch (e) {
        //     getIt<ModalService>().showAlert(
        //       context: context,
        //       title: 'Error',
        //       message: e.toString(),
        //     );
        //   }
        // }
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

  ListTile _about() {
    return ListTile(
      leading: Icon(
        MdiIcons.information,
        color: Colors.white,
      ),
      title: Text(
        'About',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Learn more about Lit Pic.',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        print('Open About');
      },
    );
  }

  ListTile _faqs() {
    return ListTile(
      leading: Icon(
        MdiIcons.carInfo,
        color: Colors.white,
      ),
      title: Text(
        'FAQs',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'See what other people are asking.',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        print('Open FAQs');
      },
    );
  }

    ListTile _helpSupport() {
    return ListTile(
      leading: Icon(
        MdiIcons.office,
        color: Colors.white,
      ),
      title: Text(
        'Help / Support',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'What can we do for you today?',
        style: TextStyle(color: Colors.grey.shade200),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: () async {
        print('Open Help / Support');
      },
    );
  }
}
