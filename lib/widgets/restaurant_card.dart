import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 80,
      width: size.width,
      padding: EdgeInsets.only(bottom: 90),
      child: ListView.builder(
        itemBuilder: (_, int index) => _RestaurantCards(),
        itemCount: 10,
      ),
    );
  }
}

class _RestaurantCards extends StatelessWidget {
  const _RestaurantCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      color: AppTheme.widgetColor,
      child: Column(
        children: [_RestaurantCardBody()],
      ),
    );
  }
}

class _RestaurantCardBody extends StatelessWidget {
  const _RestaurantCardBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'products',arguments: 'restaurant-info'),
      child: Container(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child:  FadeInImage(
                height: size.height *0.3,
                width: size.height *0.8,
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage('https://via.placeholder.com/200x300'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text('Nombre restaurante'),
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
                'Rating',
              )
            ],
          ),
          Text('Pedido Mínimo'),
          const SizedBox(height: 10,)
        ]),
      ),
    );
  }
}
