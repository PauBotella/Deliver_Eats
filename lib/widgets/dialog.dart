import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  UserF user;
  CustomDialog({Key? key, required  this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      title: const Text('Modificar Nombre de usuario',style: AppTheme.subtitleStyle,),
      backgroundColor: AppTheme.widgetColor,
      content: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: controller,


      ),
      actions: [
        TextButton(
            onPressed: () {
              if(controller.text.isNotEmpty) {
                user.username = controller.text;
                UserProvider.updateUser(user);
                Navigator.of(context).pop();
              }


              },
            child: const Text('Actualizar')
        ),
        TextButton(
            onPressed: () {Navigator.of(context).pop();},
            child: const Text('Cancelar',style: TextStyle(color: Colors.red),)
        ),
      ],
    );
  }
}
