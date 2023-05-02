import 'package:card_swiper/card_swiper.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProductSwipper extends StatelessWidget {
  final Restaurant restaurant;

  const ProductSwipper({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<Product>> list = restaurant.products;
    try {
      return FutureBuilder(
        future: list,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData) {

            if(snapshot.data.length == 0) {
              return Center(child: Column(
                children: [
                  SizedBox(height: 300,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20),child: Text('Este restaurante no tiene productos todavia',style: AppTheme.titleStyle,)),
                  CircularProgressIndicator()
                ],
              ));
            }

            return cardContent(context, snapshot.data);
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } catch (e) {
      return Container();
    }

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
                arguments: list[index]),
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
