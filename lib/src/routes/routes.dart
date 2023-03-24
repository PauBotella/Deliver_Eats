import 'package:deliver_eats/src/pages/splashScreen_page.dart';
import 'package:flutter/material.dart';

Map<String,WidgetBuilder> getRoutes() {

    return <String,WidgetBuilder> {
      //'/': (BuildContext context) => HomePage(),
      //'login': (BuildContext context) => LoginPage(),
      'splashScreen': (BuildContext context) => Splash(),
    };
}