import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../widgets/restaurant_card.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurantes'),
        centerTitle: true,
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
            child: Column(
              children: [
                RestaurantCard(),
              ],
            ),
          ),
    );
  }
}
