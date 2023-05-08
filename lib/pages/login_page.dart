import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/services/auth_service.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/auth_service_google.dart';
import '../utils/dialog.dart';
import '../utils/preferences.dart';
import '../widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isRegisterPage = false;
  bool _enabled = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  Future signInWithEmailAndPassword() async {
    await FbAuth().signInWithEmailAndPassword(
        email: _controllerEmail.text, password: _controllerPassword.text);
  }

  Future signInWithEmailAndPassword2(String email, String password) async {
    await FbAuth().signInWithEmailAndPassword(email: email, password: password);
  }

  Future createUserWithEmailAndPassword(String email, String password) async {
    try {
      await FbAuth()
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      diaglogResult(ex.message!, context, AppTheme.failAnimation, '');
      setState(() {});
    }
  }

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
                  controller: _controllerEmail,
                  isPasswordInput: false,
                  inputTxt: 'Email',
                  icon: Icons.email,
                ),
                CustomInput(
                  controller: _controllerPassword,
                  isPasswordInput: true,
                  inputTxt: 'Password',
                  icon: Icons.password,
                ),
                Visibility(
                    visible: !_isRegisterPage, child: SizedBox(height: 30)),
                Visibility(
                  visible: _isRegisterPage,
                  child: CustomInput(
                    controller: _controllerConfirmPassword,
                    isPasswordInput: true,
                    inputTxt: 'Confirm Password',
                    icon: Icons.password,
                  ),
                ),
                Visibility(
                  visible: !_isRegisterPage,
                  child: ElevatedButton(
                    onPressed: _enabled ?() async {
                      try {
                        _enabled = false;
                        setState(() {

                        });
                        await AuthService().singInWithGoogle();
                        await _createGoogleUser();
                        Navigator.pushReplacementNamed(context, 'home');
                      } catch (e) {}
                    }: null,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70, top: 30),
                  child: Row(
                    children: [
                      !_isRegisterPage
                          ? const Text(
                              '¿No estás registrado?',
                              style: TextStyle(color: AppTheme.inputBackground),
                            )
                          : const Text(
                              'O prueba a hacer login',
                              style: TextStyle(color: AppTheme.inputBackground),
                            ),
                      !_isRegisterPage
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  _isRegisterPage = true;
                                });
                              },
                              child: Text('Registrate aquí'))
                          : TextButton(
                              onPressed: () {
                                setState(() {
                                  _isRegisterPage = false;
                                });
                              },
                              child: Text('Hacer Login Aquí'))
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _enabled ? () {
                    !_isRegisterPage
                        ? _singInEmail(context)
                        : _register(context);
                  }: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 3,
                    minimumSize: Size(340, 50),
                  ),
                  child: !_isRegisterPage
                      ? const Text('Iniciar Sesión')
                      : Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _singInEmail(BuildContext context) async {
    try {
      _enabled = false;
      setState(() {

      });
      await signInWithEmailAndPassword();

      MyPreferences.email = _controllerEmail.text;
      MyPreferences.password = _controllerPassword.text;
      MyPreferences.isUserCreated = true;

      Navigator.pushReplacementNamed(context, 'home');
    } catch (e) {
      _enabled = true;
      setState(() {

      });
      diaglogResult(
          e.toString().split("]")[1], context, AppTheme.failAnimation, '');
    }
  }

  void _singInEmail2(
      BuildContext context, String email, String password) async {
    try {
      await signInWithEmailAndPassword2(email, password);

      MyPreferences.email = email;
      MyPreferences.password = password;
      MyPreferences.isUserCreated = true;
      UserProvider.addUser(UserF(
          email: email,
          username: email.split('@')[0],
          role: "cliente",
          uid: ''));

      Navigator.pushReplacementNamed(context, 'home');
    } catch (e) {
      _enabled = true;
      setState(() {

      });
      diaglogResult(
          e.toString().split("]")[1], context, AppTheme.failAnimation, '');
    }
  }

  void _register(BuildContext context) async {
    _enabled = false;
    setState(() {

    });
    print('register');
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;
    String confirmPassword = _controllerConfirmPassword.text;

    try {
      if (confirmPassword != password) {
        throw const FormatException('Las contraseñas no coinciden');
      } else if (password.length < 6) {
        throw const FormatException(
            'La contraseña ha de tener como mínimo 6 caracteres');
      }
      await createUserWithEmailAndPassword(email, password);
      _isRegisterPage = false;
      _singInEmail2(context, email, password);
    } on FormatException catch (ex) {
      _enabled = true;
      setState(() {

      });
      diaglogResult(ex.message, context, AppTheme.failAnimation, '');
    }
  }
}

extension EmailValidador on String {
  bool isEmailValid() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
    ;
  }
}

_createGoogleUser() async {
  User user = FbAuth().getUser()!;
  List<String> signInMethods =
      await FbAuth().firebaseAuth.fetchSignInMethodsForEmail(user.email!);
  bool isGoogleUser = signInMethods.contains(GoogleAuthProvider.PROVIDER_ID);

  if (isGoogleUser) {
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
      }
    });
  }
}
