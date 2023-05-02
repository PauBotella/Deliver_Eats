import 'package:deliver_eats/pages/cart_page.dart';
import 'package:deliver_eats/pages/product_crud_page.dart';
import 'package:deliver_eats/pages/product_detail.dart';
import 'package:deliver_eats/pages/product_page.dart';
import 'package:deliver_eats/pages/user_page.dart';
import 'package:flutter/material.dart';

import '../pages/add_update_restaurant_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/restaurant_crud_page.dart';
import '../pages/restaurant_page.dart';
import '../pages/splashScreen_page.dart';
Map<String,WidgetBuilder> getRoutes() {

    return <String,WidgetBuilder> {
      'home': (BuildContext context) => HomePage(),
      'login': (BuildContext context) => LoginPage(),
      'splashScreen': (BuildContext context) => Splash(),
      'products': (BuildContext context) => ProductPage(),
      'details': (BuildContext context) => ProductDetail(),
      'Rcrud': (BuildContext context) => CrudRestaurantPage(),
      'AddUpdateR': (BuildContext context) => AddUpdateRestaurant(),
      'Pcrud': (BuildContext context) => CrudProductPage(),
    };
}

Widget getPageByID(int index) {

  Map<int ,Widget> routes = {
    0: RestaurantPage(),
    1: UserPage(),
    2: CartPage(),
  };

  return routes[index]!;
}