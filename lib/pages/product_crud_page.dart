import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/restaurant.dart';
import '../models/user.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';

class CrudProductPage extends StatefulWidget {
  CrudProductPage({Key? key}) : super(key: key);

  @override
  State<CrudProductPage> createState() => _CrudProductPageState();
}

class _CrudProductPageState extends State<CrudProductPage> {
  Future<UserF> user = UserProvider.getCurrentuser();
  late Restaurant userRestaurant;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
        appBar: AppBar(
          title: const Text('Productos CRUD'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black54,
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'AddUpdateP',
                arguments: [userRestaurant,null,false]);
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
          stream: Stream.fromFuture(user),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                        child: StreamBuilder(
                      stream: Stream.fromFuture(
                          _productSlider(snapshot.data.restaurant)),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )),
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
    userRestaurant = r;
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
                  onPressed: (BuildContext context) =>
                      _deleteProducts(products[index], index, products),
                  backgroundColor: Colors.red,
                  icon: Icons.delete_forever,
                  label: 'Borrar',
                )
              ],
            ),
            child: ListTile(
                onTap: () => Navigator.pushReplacementNamed(context, 'AddUpdateP',
                    arguments: [userRestaurant,products[index],true],),
                title: Text(
                  products[index].name,
                  style: AppTheme.titleStyle,
                ),
                subtitle: Text(
                  products[index].price.toString() + AppTheme.EUROTXT,
                  style: AppTheme.priceStyle,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal,
                )));
      },
    );
  }

  _deleteProducts(Product product, int index, List<Product> algo) {
    algo.removeAt(index);
    setState(() {});
    ProductProvider.deleteProduct(product.id);
  }
}
