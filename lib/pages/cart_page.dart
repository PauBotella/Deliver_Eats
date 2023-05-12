import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

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
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/orders.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _enabled = true;
  late Future<List<Cart>> carts;
  List<Cart> cartList = [];
  double totalPrice = 0.0;
  Map<String, dynamic>? paymentIntent;

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          IconButton(
              onPressed: () => setState(() {}), icon: Icon(Icons.refresh))
        ],
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
                '${formatNumber(product.price * cantidad)} ${AppTheme.euroTxt}',
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

  _totalPrice() async {
    double precio = 0.0;
    for (Cart cart in cartList) {
      Product product = await cart.product;
      precio += product.price * cart.cantidad;
    }
    return precio;
  }

  _dialogPedido() async {
    double precio = await _totalPrice();

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
                    ' ${formatNumber(precio)} ${AppTheme.euroTxt}',
                    style: AppTheme.priceStyle,
                  )
                ])),
            actions: [
              TextButton(
                  onPressed: () {
                    try {
                      _enabled ? makePayment() : null;
                    } catch (e) {}

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
    _enabled = false;
    setState(() {});
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

    for (var value in cartList) {
      CartProvider.deleteCart(value.id);
    }
    ;

    cartList.clear();
    setState(() {});

    _enabled = true;
    setState(() {});
  }

  Future<void> makePayment() async {
    totalPrice = await _totalPrice();

    try {

      if (cartList.isEmpty) {
        throw Exception('Añade algún producto al carrito');
      }

      paymentIntent = await createPaymentIntent('EUR', totalPrice);
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Pau'))
          .then((value) {});

      displayPaymentSheet();
    } catch (e) {
      _enabled = true;
      setState(() {});
      diaglogResult(
          e.toString().split(":")[1], context, AppTheme.failAnimation, '');
    }
  }

  displayPaymentSheet() async {

    await Stripe.instance.presentPaymentSheet().then((value) async {
      await _hacerPedido(totalPrice);
      Navigator.pushReplacementNamed(context, 'home');
      paymentIntent = null;
    }).onError((error, stackTrace) {
      print('Error is:--->$error $stackTrace');
    });
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String currency, double precio) async {
    Map<String, dynamic> body = {
      'amount': (precio * 100).toInt().toString(), //se lo tienes que pasar en centimos porque si no no lo coge bien
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':
            'Bearer sk_test_51N6wTUGrl0ywMA1aXqKill9iE9LOmbPb7umZs0j2vL4vMp36ChmuAwVTj4DHiLlSrsMB9UX1oXx1mgygXbe0Gwxo00EvTWiVAQ',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    // ignore: avoid_print
    print('Payment Intent Body->>> ${response.body.toString()}');
    return jsonDecode(response.body);
  }
}
