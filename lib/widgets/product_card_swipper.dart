import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class ProductSwipper extends StatelessWidget {
  final Restaurant restaurant;

  const ProductSwipper({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<Product>> list = restaurant.products;
    print("MERDOLO" + list.toString());
    return FutureBuilder(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData) {
          print('SI K HAY ${snapshot.data}');
        }
        return cardContent(context, snapshot.data);
      },
    );
  }
}

cardContent(BuildContext context, List<Product> list) {
  final size = MediaQuery.of(context).size;
  return Container(
      width: double.infinity,
      height: size.height * 0.50,
      child: Swiper(
        itemCount: list.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',
                arguments: 'product-info'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(list[index].image),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ));
}
