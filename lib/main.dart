import 'package:deliver_eats/routes/routes.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MyPreferences.init();
  runApp(MyApp());
}

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
