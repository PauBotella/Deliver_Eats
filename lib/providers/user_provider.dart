import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/user.dart';

class UserProvider {
  static final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  static addUser(UserF user) {
    usersRef.add(user.toMap());
  }

}