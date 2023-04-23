import 'package:deliver_eats/models/food_type.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const RestaurantCard({required this.snapshot, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<Restaurant> restaurants =
        snapshot.data!.docs.map<Restaurant>((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      Restaurant restaurant = Restaurant.fromJson(data);
      return restaurant;
    }).toList();

    return Container(
        height: size.height - 80,
        width: size.width,
        child: ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (BuildContext context, int index) {
              Restaurant restaurant = restaurants[index];
              return _RestaurantCards(restaurant: restaurant);
            }));
  }
}

class _RestaurantCards extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantCards({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      color: AppTheme.widgetColor,
      child: Column(
        children: [
          _RestaurantCardBody(
            restaurant: restaurant,
          )
        ],
      ),
    );
  }
}

class _RestaurantCardBody extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantCardBody({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () =>{Navigator.pushNamed(context, 'products',arguments: restaurant)},
      child: Container(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                height: size.height * 0.3,
                width: size.height * 0.8,
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(restaurant.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(restaurant.name),
            ],
          ),
          
          FutureBuilder(
            future: restaurant.type,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
              if(snapshot.hasData) {
                return Text(snapshot.data!.type);
              } else {
                return Text('');
              }
            },
            
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                size: 20,
                color: Colors.yellow,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                restaurant.rating.toString(),
              )
            ],
          ),
          Text('Pedido Mínimo' + restaurant.minimumOrder.toString()),
          Text(restaurant.address),
          const SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }
}
