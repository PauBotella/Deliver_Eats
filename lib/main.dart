import 'package:deliver_eats/src/routes/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: getRoutes(),
      initialRoute: 'splashScreen',
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Deliver Eats'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
