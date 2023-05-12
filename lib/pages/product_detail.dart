import 'package:deliver_eats/models/cart.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/cart_provider.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/product.dart';
import '../utils/dialog.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments! as Product;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.tealAccent),
          flexibleSpace: Stack(children: [
            Positioned.fill(
              child: Container(
                child: FadeInImage(
                  placeholder: AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(product.image),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(children: [
              Text(
                formatNumber(product.rating),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepOrange),
              ),
              RatingBarIndicator(
                rating: product.rating,
                unratedColor: Colors.white70,
                itemCount: 5,
                itemSize: 50,
                itemPadding: EdgeInsets.all(5),
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.widgetColor),
              child: Center(
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                  style: AppTheme.subtitleStyle,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Row(children: [
              Text(
                'Por tan solo un total de ',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              Text(
                '${formatNumber(product.price)}' + AppTheme.euroTxt,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                _addProductToCart(Future.value(product), context);
              },
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
        ],
      ),
    );
  }
}

_addProductToCart(Future<Product> product, BuildContext context) async {
  Future<UserF> user = UserProvider.getCurrentuser();

  Cart cart = Cart(quantity: 1, user: user, id: '', product: product);

  await CartProvider.addCart(cart);

  diaglogResult('Producto añadido al carrito con éxito', context,
      AppTheme.checkAnimation, '');
}
