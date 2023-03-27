
import 'package:firebase_auth/firebase_auth.dart';

class FbAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? getUser() {
    return firebaseAuth.currentUser;
  }

  String inputData() {
    final User user = firebaseAuth.currentUser!;
    final uid = user.uid;
    return uid;
  }
  Future signInWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future createUserWithEmailAndPassword({
    required String email,
    required String password
  }) async {
    await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future signOut() async{
    await firebaseAuth.signOut();
  }

}