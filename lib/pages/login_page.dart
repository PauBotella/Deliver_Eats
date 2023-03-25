import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

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
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Ink(
                            child: Icon(
                              Icons.email,
                              color: Colors.blueGrey,
                            ),
                          ),
                          label: Text('Email')),
                    ),
                  )
                ],
              ),
            ),
    ),
        )
    );
  }
}
