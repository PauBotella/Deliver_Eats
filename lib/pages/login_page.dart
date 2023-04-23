import 'package:deliver_eats/services/auth_service.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../services/auth_service_google.dart';
import '../utils/preferences.dart';
import '../widgets/custom_input.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isRegisterPage = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword =
      TextEditingController();

  Future signInWithEmailAndPassword() async {
    try {
      await FbAuth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (ex) {
      _dialog(ex.message!);
      setState(() {});
    }
  }

  Future signInWithEmailAndPassword2(String email, String password) async {
    try {
      await FbAuth()
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      //Cambiar mensaje de la excepción
      _dialog(ex.message!);
      setState(() {});
    }
  }

  Future createUserWithEmailAndPassword(String email, String password) async {
    try {
      await FbAuth()
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      //Cambiar mensaje de la excepción
      _dialog(ex.message!);
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
                    onPressed: () async {
                      var result = await AuthService().singInWithGoogle();

                      Navigator.pushReplacementNamed(context, 'home');
                    },
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
                  onPressed: () {
                    !_isRegisterPage
                        ? _singInEmail(context)
                        : _register(context);
                  },
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

  void _singInEmail(BuildContext context) {
    signInWithEmailAndPassword();
    FbAuth().firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        MyPreferences.email = _controllerEmail.text;
        MyPreferences.password = _controllerPassword.text;
        Navigator.pushReplacementNamed(context, 'home');
      }
    });
  }

  void _singInEmail2(BuildContext context, String email, String password) {
    signInWithEmailAndPassword2(email, password);
    FbAuth().firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        MyPreferences.email = email;
        MyPreferences.password = password;
        UserProvider.addUser(UserF(email: user.email!, username: user.email!.split('@')[0], role: "cliente"));
        Navigator.pushReplacementNamed(context, 'home');
      }
    });
  }

  void _register(BuildContext context) {
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
      createUserWithEmailAndPassword(email, password);
      _singInEmail2(context, email, password);
//Cambiar mensaje de la excepción
    } on FormatException catch (ex) {
      _dialog(ex.message);
    }
  }

  void _dialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
          );
        });
  }
}
