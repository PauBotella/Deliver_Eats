import 'package:deliver_eats/routes/routes.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: 'splashScreen',
      routes: getRoutes(),
      title: 'Material App',
    );
  }
}
