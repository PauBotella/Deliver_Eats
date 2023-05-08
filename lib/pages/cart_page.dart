import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/cart.dart';
import 'package:deliver_eats/models/order_item.dart';
import 'package:deliver_eats/providers/cart_provider.dart';
import 'package:deliver_eats/providers/order_item_provider.dart';
import 'package:deliver_eats/providers/order_provider.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/orders.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Cart>> carts;
  List<Cart> cartList = [];
  bool primeraVez = true;

  @override
  void initState() {
    super.initState();
    carts = CartProvider.getCarts();
    _loadData();
  }

  _loadData() async {
    print('load');
    var list = await carts;
    cartList = list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        onPressed: () => _dialogPedido(),
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
              title: Text(
                product.name,
                style: AppTheme.subtitleStyle,
              ),
              subtitle: Text(
                '${NumberFormat("#,##0.00", "es_ES").format(product.price * cantidad)} ${AppTheme.euroTxt}',
                style: AppTheme.priceStyle,
              ),
              trailing: Wrap(
                children: [
                  Text(
                    cantidad.toString(),
                    style:
                        TextStyle(fontSize: 17, color: Colors.lightBlueAccent),
                  ),
                  SizedBox(
                    width: 70,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.teal,
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  void suma1(int index) {
    setState(() {
      cartList[index].cantidad++;
      CartProvider().updateCart(cartList[index]);
    });
  }

  void borrar(int index) {
    setState(() {
      if (cartList[index].cantidad <= 1) {
        CartProvider.deleteCart(cartList[index].id);
        cartList.removeAt(index);
      } else {
        cartList[index].cantidad--;
        CartProvider().updateCart(cartList[index]);
      }
    });
  }

  _dialogPedido() async {
    double precio = 0.0;
    for (Cart cart in cartList) {
      Product product = await cart.product;
      precio += product.price * cart.cantidad;
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
                child: const Text(
              'Pedido',
              style: AppTheme.titleStyle,
            )),
            backgroundColor: AppTheme.widgetColor,
            content: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(children: [
                  Text(
                    'Coste Total pedido',
                    style: AppTheme.subtitleStyle,
                  ),
                  Text(
                    ' ${NumberFormat("#,##0.00", "es_ES").format(precio)} ${AppTheme.euroTxt}',
                    style: AppTheme.priceStyle,
                  )
                ])),
            actions: [
              TextButton(
                  onPressed: () {
                    _hacerPedido(precio);
                  },
                  child: const Text('Hacer pedido',
                      style: TextStyle(color: Colors.blue))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }

  _hacerPedido(double precio) async {
    try {
      if (cartList.isEmpty) {
        throw Exception('Añade algún producto al carrito');
      }

      UserF user = await UserProvider.getCurrentuser();
      DateTime hoy = DateTime.now();
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      String date = dateFormat.format(hoy);

      Orders order = Orders(
          date: date, user: Future.value(user), id: '', totalPrice: precio);

      DocumentReference<Map<String, dynamic>> orderRef =
          await OrderProvider.addOrder(order);

      DocumentSnapshot<Map<String, dynamic>> snapshot = await orderRef.get();
      final Map<String, dynamic> orderData = snapshot.data()!;
      Orders firebaseOrder = Orders.fromJson(orderData, orderRef.id);

      for (Cart c in cartList) {
        OrderItem item = OrderItem(
            cantidad: c.cantidad,
            order: Future.value(firebaseOrder),
            product: c.product);

        await OrderItemProvider.addOrderItem(item);
      }

      cartList.clear();

      setState(() {});
      diaglogResult(
          'Pedido Completado', context, AppTheme.payAnimation, 'home');
    } catch (e) {
      print(e);
      diaglogResult(
          e.toString().split(":")[1], context, AppTheme.failAnimation, '');
    }
  }
}
