import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/restaurant.dart';
import '../models/user.dart';
import '../providers/restaurant_provider.dart';
import '../theme/app_theme.dart';

class CrudProductPage extends StatelessWidget {
  CrudProductPage({Key? key}) : super(key: key);

  Future<UserF> user = UserProvider.getCurrentuser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Restaurantes CRUD'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54,
          onPressed: () {
            Navigator.pushNamed(context, 'AddUpdateR');
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: user,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(child: FutureBuilder(
                      future: _productSlider(snapshot.data.restaurant),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(snapshot.hasData) {
                          return snapshot.data;
                        } else {
                          return Center(child: CircularProgressIndicator(),);
                        }
                      },)),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }


  Future<Widget> _productSlider(Future<Restaurant> restaurant) async {
    Restaurant r = await restaurant;
    List<Product> products = await r.products;

    print(products[0].name);
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return Slidable(
            endActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  key: UniqueKey(),
                  autoClose: false,
                  onPressed: (BuildContext context) => print('hola'),
                  backgroundColor: Colors.red,
                  icon: Icons.delete_forever,
                  label: 'Borrar',
                )
              ],
            ),
            child: ListTile(
                onTap: () => print('update'),
                title: Text(
                  products[index].name,
                  style: AppTheme.titleStyle,
                ),
                subtitle: Text(
                  products[index].price.toString() + AppTheme.euroTxt,
                  style: AppTheme.priceStyle,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal,
                )));
      },
    );
  }
}