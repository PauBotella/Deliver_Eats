import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:deliver_eats/services/auth_service.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User currentUser = FbAuth().getUser()!;

    Map<String, Function()> clientOptions = {
      'Cerrar Sesión': () => {
    FbAuth().firebaseAuth.signOut(),

    FbAuth().firebaseAuth.authStateChanges().listen((user) {
      MyPreferences.email = '';
      MyPreferences.password = '';
      Navigator.pushReplacementNamed(context, 'login');
    })
      },
      'Modificar Datos': () => print('modificar')
    };
    Map<String, Function()> encargadoOptions = {
      'Crear Producto': () => print('crear'),
      'Ver registros': () => print('ver')
    };
    encargadoOptions.addAll(clientOptions);
    Map<String, Function()> adminOptions =
        Map<String, Function()>.from(clientOptions);
    adminOptions.addAll(encargadoOptions);
    adminOptions['Crear Restaurante'] = () => print('crear restaurante');

    Future<UserF> user = UserProvider.usersRef
        .where('email', isEqualTo: currentUser.email)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (var element in snapshot.docs) {
          return UserF.fromJson(element.data() as Map<String, dynamic>);
        }
      }
      return UserF(email: '', username: '', role: '');
    });

    Map<String, Function()> getOptionsList(UserF user) {
      if (user.role == 'cliente') {
        return clientOptions;
      } else if (user.role == 'encargado') {
        return encargadoOptions;
      } else {
        return adminOptions;
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: FutureBuilder(
            future: user,
            builder: (BuildContext context, AsyncSnapshot<UserF> snapshot) {
              if (snapshot.hasData) {
                UserF user = snapshot.data!;
                Map<String, Function()> options = getOptionsList(user);
                List<String> keys = options.keys.toList();
                List<Function()> values = options.values.toList();
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircleAvatar(
                          backgroundColor: AppTheme.widgetColor,
                          radius: 50,
                          child: Text(
                            user.email[0].toUpperCase(),
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(user.email),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: size.width - 50,
                        height: size.height - 400,
                        child: ListView.builder(
                          itemCount: keys.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              trailing: Icon(Icons.keyboard_arrow_right),
                              title: Text(keys[index]),
                              onTap: values[index],

                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
