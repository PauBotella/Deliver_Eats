import 'package:flutter/material.dart';

class RatedProducts extends StatelessWidget {
  const RatedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
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
              child:ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemBuilder: (_, int index) => _ProductCard()
              )
          )
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details',arguments: 'product-info'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const FadeInImage(
                width: 130,
                height: 170,
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage('https://via.placeholder.com/300x400'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5,),
          Text(
            'Hamburguesa super duper gitana infernal ef',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

