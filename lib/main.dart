import 'package:deliver_eats/routes/routes.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/utils/preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await MyPreferences.init();
    Stripe.publishableKey = 'pk_test_51N6wTUGrl0ywMA1a21oiMeOrRQI6zMiycTkYgfMMpiubQ0Ei9AGFs48S7VxFYoSG0vqZUV7X3ffQIQ2yBQCUP5EL00GWx0UIM6';
    runApp(MyApp());
  });
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