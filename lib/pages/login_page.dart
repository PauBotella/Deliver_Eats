import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*
      Gesture detector, lo uso para cuando tienes el focus del teclado en el TextFormField
      Cuando apriete a cualquier sitio de la pantalla que no sea el TextFormField el focus se quitará
      */
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),
                    const SizedBox(height: 30),
                    CustomInput(
                      isPasswordInput: false,
                      inputTxt: 'Email',
                      icon: Icons.email,
                    ),
                    CustomInput(
                      isPasswordInput: true,
                      inputTxt: 'Password',
                      icon: Icons.password,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.inputBackground,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 3,
                        minimumSize: Size(100, 90),
                      ),
                      child: Container(
                        child: const FadeInImage(
                          placeholder: AssetImage('assets/loading-gif.gif'),
                          image: AssetImage(
                            'assets/google-logo.png',
                          ),
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 70, top: 30),
                      child: Row(
                        children: [
                          Text(
                            '¿No estás registrado?',
                            style: TextStyle(color: AppTheme.inputBackground),
                          ),
                          TextButton(
                              onPressed: () {}, child: Text('Registrate aquí'))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Iniciar Sesión'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 3,
                        minimumSize: Size(340, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      )
    );
  }
}
