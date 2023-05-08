import 'package:deliver_eats/routes/routes.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  BottomNav? bNav;

  @override
  void initState() {
    super.initState();
    bNav = BottomNav(getIndex: (currentIndex) {
      index = currentIndex;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bNav,
      body: getPageByID(index),
    );
  }
}
