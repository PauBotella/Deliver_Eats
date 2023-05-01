import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/product.dart';
import '../models/restaurant.dart';
import '../providers/restaurant_provider.dart';
import '../theme/app_theme.dart';

class CrudRestaurantPage extends StatefulWidget {
  const CrudRestaurantPage({Key? key}) : super(key: key);

  @override
  State<CrudRestaurantPage> createState() => _CrudRestaurantPageState();
}

class _CrudRestaurantPageState extends State<CrudRestaurantPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurantes CRUD'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: RestaurantProvider().getRestaurants(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<Restaurant> restaurants = snapshot.data!.docs
                .map<Restaurant>((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Restaurant restaurant = Restaurant.fromJson(data,document.id);
              return restaurant;
            }).toList();

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: restaurants.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Slidable(
                            endActionPane: ActionPane(
                              motion: DrawerMotion(),
                              children: [
                                SlidableAction(
                                  key: UniqueKey(),
                                  autoClose: false,
                                  onPressed: (BuildContext context) => _deleteRestaurant(restaurants[index]),
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete_forever,
                                  label: 'Borrar',
                                )
                              ],
                            ),
                            child: _productSlider(restaurants[index]));
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container();
        },
      ),
    );
  }
  _productSlider(Restaurant restaurant) {
    return ListTile(
        onTap: () => print('update'),
        title: Text(
          restaurant.name,
          style: AppTheme.titleStyle,
        ),
        subtitle: Text(
          restaurant.address,
          style: AppTheme.subtitleStyle,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.teal,
        ));
  }

  _deleteRestaurant(Restaurant restaurant) {
      RestaurantProvider.deleteRestaurant(restaurant.id);
  }
}

