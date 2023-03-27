import 'package:deliver_eats/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);

  final user = FbAuth().getUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(user!.email!)),
    );
  }
}


