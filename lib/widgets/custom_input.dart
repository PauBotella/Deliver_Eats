import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  bool isPasswordInput;
  String inputTxt;
  IconData icon;
  TextEditingController controller;

  CustomInput({
    Key? key,
    required this.isPasswordInput,
    required this.inputTxt,
    required this.icon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordInput ? true : false,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            prefixIcon: Ink(
              child: Icon(
                icon,
                color: AppTheme.widgetColor,
              ),
            ),
            label: Text(inputTxt)),
      ),
    );
  }
}
