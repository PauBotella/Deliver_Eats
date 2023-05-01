import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

void dialog(String msg,BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.widgetColor,
          title: Text(msg,style: AppTheme.subtitleStyle,),
        );
      });
}