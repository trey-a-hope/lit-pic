import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3.0,
          ),
          SizedBox(height: 20),
          Text(
            'Loading',
            style: TextStyle(fontSize: 15.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
