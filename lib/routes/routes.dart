import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/splashScreen_page.dart';

Map<String,WidgetBuilder> getRoutes() {

    return <String,WidgetBuilder> {
      'home': (BuildContext context) => HomePage(),
      'login': (BuildContext context) => LoginPage(),
      'splashScreen': (BuildContext context) => Splash(),
    };
}