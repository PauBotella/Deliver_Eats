import 'package:deliver_eats/pages/cart_page.dart';
import 'package:deliver_eats/pages/product_detail.dart';
import 'package:deliver_eats/pages/product_page.dart';
import 'package:deliver_eats/pages/user_page.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/restaurant_page.dart';
import '../pages/splashScreen_page.dart';
Map<String,WidgetBuilder> getRoutes() {

    return <String,WidgetBuilder> {
      'home': (BuildContext context) => HomePage(),
      'login': (BuildContext context) => LoginPage(),
      'splashScreen': (BuildContext context) => Splash(),
      'products': (BuildContext context) => ProductPage(),
      'details': (BuildContext context) => ProductDetail(),
    };
}

Widget getPageByID(int index) {

  Map<int ,Widget> routes = {
    0: const RestaurantPage(),
    1: const UserPage(),
    2: const CartPage(),
  };

  return routes[index]!;
}