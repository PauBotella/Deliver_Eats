import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

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
          flexibleSpace: Stack(
            children: [Positioned.fill(
              child: Container(
                child: FadeInImage(placeholder: AssetImage('assets/no-image.jpg') ,image: NetworkImage(product.image), fit: BoxFit.fill,),
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
                              fontWeight: FontWeight.bold
                            ),
                        ),
                  ),
                ),
              )
      ]
          ),
        ),
      ),
        body: Column(
            children: [

              const SizedBox(height: 50,),
                Padding(
                  padding: EdgeInsets.only(left: 160),
                  child: Row(
                    children: [
                      Icon(Icons.star,color: Colors.yellow,),
                      Text(product.rating.toString())
                    ],
                  ),
                ),
              const SizedBox(height: 50,),
              Text('Por tan solo un total de ' + product.price.toString() + " Euros"),
              const SizedBox(height: 50,),
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
            ],
          ),

    );
  }
}