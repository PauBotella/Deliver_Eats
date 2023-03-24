import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1C2833),
      body: splashContent(),
    );
  }

  Widget splashContent() {
    return Center(
      child: Container(

        child: Lottie.asset(
          'assets/splash_animation.json',
          width: 300,
          height: 300
        ),
      ),
    );
  }

}
