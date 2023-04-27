import 'package:deliver_eats/models/cart.dart';
import 'package:deliver_eats/providers/cart_provider.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Cart>> carts;
  List<Cart> cartList = [];

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
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  child: Text('Listado de productos'),
                ),
                Text('Total precio')
              ],
            ),
            const Divider(
              color: Colors.white,
              thickness: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          autoClose: false,
                          onPressed: suma1,
                          backgroundColor: Colors.indigo,
                          icon: Icons.add,
                          label: 'Añadir',
                        ),
                        SlidableAction(
                          autoClose: false,
                          onPressed: borrar,
                          backgroundColor: Colors.red,
                          icon: Icons.delete_forever,
                          label: 'Borrar',
                        )
                      ],
                    ),
                    child: _ProductSlider(
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

  _ProductSlider(Future<Product> product, int cantidad) {
    return FutureBuilder(
        future: product,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshotD) {
          if (snapshotD.hasData) {
            return ListTile(
                title: Row(children: [
              Text(snapshotD.data.name),
              Padding(
                  padding: const EdgeInsets.only(left: 100, top: 20),
                  child: Text(cantidad.toString()))
            ]));
          } else {
            return Container();
          }
        });
  }

  void suma1(BuildContext context) {
    print('sumar1');
  }

  void borrar(BuildContext context) {
    print('borrar');
  }
}
