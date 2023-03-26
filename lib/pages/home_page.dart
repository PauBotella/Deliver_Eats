import 'package:deliver_eats/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  User get currentUser => FbAuth().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text((currentUser.email)!),
        ),
        body: Center(
          child: Container(
            child: Text('Home'),
          ),
        ),
      );
  }
}
