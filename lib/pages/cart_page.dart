import 'package:deliver_eats/models/cart.dart';
import 'package:deliver_eats/providers/cart_provider.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/product.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Cart>> carts;
  List<Cart> cartList = [];
  double precio = 0.0;
  bool primeraVez = false;

  @override
  void initState() {
    super.initState();
    carts = CartProvider().getCarts();
    _loadData();
  }

  _loadData() async {
    var list = await carts;
    setState(() {
      cartList = list;
      list.forEach((element) {
        element.product.then((value) {
          precio += value.price;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.widgetColor,
        onPressed: () {},
        child: const Icon(Icons.add_card),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          key: UniqueKey(),
                          autoClose: false,
                          onPressed: (BuildContext context) => suma1(index),
                          backgroundColor: Colors.indigo,
                          icon: Icons.add,
                          label: 'Añadir',
                        ),
                        SlidableAction(
                          key: UniqueKey(),
                          autoClose: false,
                          onPressed: (BuildContext context) => borrar(index),
                          backgroundColor: Colors.red,
                          icon: Icons.delete_forever,
                          label: 'Borrar',
                        )
                      ],
                    ),
                    child: _productSlider(
                      cartList[index].product,
                      cartList[index].cantidad,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _productSlider(Future<Product> product, int cantidad) {
    return FutureBuilder(
        future: product,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshotD) {
          if (snapshotD.hasData) {
            Product product = snapshotD.data!;
            return ListTile(
              title: Text(product.name),
              subtitle: Text(
                  '${NumberFormat("#,##0.00", "es_ES").format(product.price * cantidad)}€'),
              trailing: Wrap(
                children: [
                  Text(cantidad.toString(),style: TextStyle(fontSize: 17),),
                  SizedBox(width: 70,),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  void suma1(int index) {
    setState(() {
      cartList[index].cantidad++;
    });
    _loadData();
  }

  void borrar(int index) {
    setState(() {
      if (cartList[index].cantidad <= 1) {
        cartList.removeAt(index);
      } else {
        cartList[index].cantidad--;
      }
    });
    _loadData();
  }
}
