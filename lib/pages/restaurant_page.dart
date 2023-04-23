import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/providers/restaurant_provider.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../widgets/restaurant_card.dart';

class RestaurantPage extends StatelessWidget {
   RestaurantPage({Key? key}) : super(key: key);

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
      body: StreamBuilder<QuerySnapshot>(
        stream: RestaurantProvider().getRestaurants(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Ocurrió un error al obtener los datos.'),);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          return
              RestaurantCard(snapshot: snapshot);

        },
          ),
    );
  }
}
