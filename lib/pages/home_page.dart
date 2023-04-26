import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/routes/routes.dart';
import 'package:deliver_eats/services/auth_service.dart';
import 'package:deliver_eats/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  BottomNav? bNav;

  @override
  void initState() {
    super.initState();
    bNav = BottomNav(getIndex: (currentIndex) {
      setState(() {
        index = currentIndex;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = FbAuth().getUser()!;
    Future<List<String>> signInMethods =
        FbAuth().firebaseAuth.fetchSignInMethodsForEmail(user.email!);
    return FutureBuilder(
      future: signInMethods,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          bool isGoogleUser = snapshot.data.contains(GoogleAuthProvider.PROVIDER_ID);

          if (!MyPreferences.isUserCreated && isGoogleUser) {
            UserProvider.usersRef
                .where('email', isEqualTo: user.email)
                .get()
                .then((QuerySnapshot query) {
              if (query.docs.isEmpty) {
                UserProvider.addUser(UserF(
                    email: user.email!,
                    username: user.email!.split('@')[0],
                    role: "cliente"));
                MyPreferences.isUserCreated = true;
              } else {
                MyPreferences.isUserCreated = true;
              }
            });
          }
        }
        return Scaffold(
          bottomNavigationBar: bNav,
          body: getPageByID(index),
        );
        ;
      },
    );
  }
}
