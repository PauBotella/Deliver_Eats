import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:deliver_eats/widgets/product_card_swipper.dart';
import 'package:deliver_eats/widgets/rated_products.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = ModalRoute.of(context)!.settings.arguments! as Restaurant;
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        centerTitle: true,
      ),
      body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProductSwipper(restaurant: restaurant),
                    RatedProducts(restaurant: restaurant),
                  ],
                ),
              ),
        )
    );
  }
}
