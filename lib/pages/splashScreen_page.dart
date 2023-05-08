import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/auth_service.dart';
import '../utils/preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    timer();
  }

  timer() {
    return Timer(const Duration(seconds: 4), route);
  }

  route() {
    if (MyPreferences.email != '') {
      Future signInWithEmailAndPassword() async {
        try {
          await FbAuth().signInWithEmailAndPassword(
              email: MyPreferences.email, password: MyPreferences.password);
        } on FirebaseAuthException catch (ex) {}
      }

      signInWithEmailAndPassword();
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      print('No hay');
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xff1C2833),
      body: splashContent(),
    );
  }

  Widget splashContent() {
    return Center(
      child: Container(
        child: Lottie.asset('assets/splash_animation.json',
            width: 300, height: 300),
      ),
    );
  }
}
