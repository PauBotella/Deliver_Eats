import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

diaglogResult(String txt,BuildContext context,String path) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppTheme.widgetColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200.0,
                width: 200.0,
                child:Lottie.asset(path)
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(txt,style: AppTheme.subtitleStyle,),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        );
      });
}