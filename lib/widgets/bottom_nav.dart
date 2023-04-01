import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../theme/app_theme.dart';

class BottomNav extends StatefulWidget {
  final Function getIndex;
  const BottomNav({Key? key, required this.getIndex}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();

}

class _BottomNavState extends State<BottomNav>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GNav(
          backgroundColor: Colors.black54,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: AppTheme.widgetColor,
          gap: 8,
          padding: const EdgeInsets.all(13),
          onTabChange: (index) {
            setState(() {
              widget.getIndex(index);
            });
          },
          tabs: const [
            GButton(icon: Icons.restaurant,text: 'Restaurantes',),
            GButton(icon: Icons.person,text: 'Perfil',),
            GButton(icon: Icons.shopping_cart,text: 'Carrito',),
          ],
        ),
      ),
    );
  }
}