import 'package:flutter/material.dart';
import 'package:litpic/pages/authentication/login_page.dart';

class LoggedOutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 70,
        width: 300,
        child: Column(
          children: <Widget>[
            Text('Must Login To Use This Feature'),
            RaisedButton(
              child: Text('Login Now'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
