import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:deliver_eats/services/auth_service.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/utils/dialog.dart';
import 'package:deliver_eats/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/dialog.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User currentUser = FbAuth().getUser()!;
  @override
  void initState() {
    _createGoogleUser(currentUser);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final userStream = UserProvider.usersRef
        .where('email', isEqualTo: currentUser.email)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((doc) => UserF.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .firstWhere((user) => true, orElse: () => UserF(email: '', username: '', role: '',uid: '')));

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: StreamBuilder<UserF>(
            stream: userStream,
            builder: (context,snapshot) {
              Map<String, Function()> clientOptions = {
                'Cerrar Sesión': () => _logOut(context),
                'Modificar Datos': () => _modify(context,snapshot.data!)
              };
              Map<String, Function()> encargadoOptions = {
                'Productos': () => _goProducts(context),
                'Ver registros': () => _goOrders(context)
              };
              encargadoOptions.addAll(clientOptions);
              Map<String, Function()> adminOptions =
              Map<String, Function()>.from(clientOptions);
              adminOptions.addAll(clientOptions);
              adminOptions['Restaurantes'] =
                  () => _goRestaurants(context);

              adminOptions['Users'] =
                  () => _goUsers(context);

              adminOptions['Ver registros'] =
                  () => _goOrders(context);

              Map<String, Function()> getOptionsList(UserF user) {
                if (user.role == 'cliente') {
                  return clientOptions;
                } else if (user.role == 'encargado') {
                  return encargadoOptions;
                } else {
                  return adminOptions;
                }
              }

              if (snapshot.hasData) {
                UserF user = snapshot.data!;
                Map<String, Function()> options = getOptionsList(user);
                List<String> keys = options.keys.toList();
                List<Function()> values = options.values.toList();
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30),
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
                        height: 25,
                      ),
                      Text(user.username,style: AppTheme.titleStyle,),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: Container(
                          width: size.width - 50,
                          height: size.height - 400,
                          child: ListView.builder(
                            itemCount: keys.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right,color: Colors.teal,),
                                title: Text(keys[index],style: AppTheme.subtitleStyle,),
                                onTap: values[index],
                              );
                            },
                          ),
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

_createGoogleUser(User user) async {
  List<String> signInMethods =
  await FbAuth().firebaseAuth.fetchSignInMethodsForEmail(user.email!);

  bool isGoogleUser = signInMethods.contains(GoogleAuthProvider.PROVIDER_ID);

  if (MyPreferences.googleMap == '' && isGoogleUser) {
    UserProvider.usersRef
        .where('email', isEqualTo: user.email)
        .get()
        .then((QuerySnapshot query) {
      if (query.docs.isEmpty) {
        UserProvider.addUser(UserF(
            email: user.email!,
            username: user.email!.split('@')[0],
            uid: '',
            role: "cliente"));
        MyPreferences.googleMap += '1';
      } else {
        MyPreferences.googleMap += '1';
      }
    });
  }
}

_goOrders(BuildContext context) {

  Navigator.pushNamed(context, 'orders');

}

_goUsers(BuildContext context) {
diaglogResult('En construcción', context,AppTheme.noDisponibleAnimation);
}

_logOut(BuildContext context) async {
  MyPreferences.email = '';
  MyPreferences.password = '';
  await FbAuth().firebaseAuth.signOut();
  Navigator.pushReplacementNamed(context, 'login');
}

_goProducts(BuildContext context) {
  Navigator.pushNamed(context, 'Pcrud');
}
_goRestaurants(BuildContext context) {
  Navigator.pushNamed(context, 'Rcrud');
}

_modify(BuildContext context,UserF userF) {
  showDialog(context: context, builder: (_) {
    return CustomDialog(user: userF,);
  });
}