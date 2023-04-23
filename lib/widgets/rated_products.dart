import 'package:deliver_eats/models/restaurant.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class RatedProducts extends StatelessWidget {
  final Restaurant restaurant;

  const RatedProducts({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> rateds = [];
    return Container(
        width: double.infinity,
        height: 260,
        child: FutureBuilder(
          future: restaurant.products,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              for (Product p in snapshot.data) {
                if (p.rating > 4) rateds.add(p);
              }
            }

            return Column(
              children: [
                Center(
                  child: Text(
                    'Más votados',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: rateds.length,
                        itemBuilder: (_, int index) => card(rateds[index], context)
                    )
                )
              ],
            );
          },
        ));
  }
}

card(Product product, BuildContext context) {
  return Container(
    width: 130,
    height: 190,
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Column(
      children: [
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'details', arguments: product),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              width: 130,
              height: 170,
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(product.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          product.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
