import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments! as Product;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: _CustomAppBar(product: product,),
            )
          ];
        },
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 60,
                ),
                    _CardAndTitle(product: product),
                const SizedBox(
                  height: 50,
                ),
                 Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    product.description,
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 3,
                      minimumSize: const Size(340, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shopping_cart),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Añadir al carrito')
                      ],
                    ),
                  ),
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Product product;
  const _CustomAppBar({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.widgetColor,
      expandedHeight: 190,
      floating: true,
      snap: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(product.name,style: TextStyle(color: Colors.white),),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(product.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _CardAndTitle extends StatelessWidget {
  final Product product;
  const _CardAndTitle({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              height: 150,
              width: 155,
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(product.image),
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 50),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Pato Pekin', // 16 CARACTERES SI NO EXPLOTA LO DEJARÉ EN 15
                  style: textTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Precio "+product.price.toString(),
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
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
                      product.rating.toString(),
                      style: textTheme.caption,
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}