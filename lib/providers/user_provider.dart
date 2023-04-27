import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class UserProvider {
  static final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  static addUser(UserF user) {
    usersRef.add(user.toMap());
  }

  static Future<UserF> getCurrentuser() {

    User user = FbAuth().getUser()!;

    Future<UserF> userF = usersRef.where('email', isEqualTo: user.email).get().then((QuerySnapshot query) {

      return UserF.fromJson(query.docs[0].data() as Map<String,dynamic>, query.docs[0].id);

    });
    return userF;
  }
}