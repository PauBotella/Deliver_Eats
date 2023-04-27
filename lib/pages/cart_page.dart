import 'package:deliver_eats/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Carrito'),centerTitle: true,),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.widgetColor,

          onPressed: () {  },
        child: Icon(Icons.add_card),

      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60,vertical: 20),
                  child: Text('Listado de productos'),
                ),
                Text('Total precio')
              ],
            ),
            const Divider(color: Colors.white,thickness: 5,),
            Container(
              height: size.height -260,
              width: double.infinity,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        autoClose: false,
                          onPressed: sumar1,
                        backgroundColor: Colors.indigo,
                        icon: Icons.add,
                        label: 'Añadir',

                      ),
                      SlidableAction(
                        autoClose: false,
                        onPressed: delete1,
                        backgroundColor: Colors.red,
                        icon: Icons.delete_forever,
                        label: 'Borrar',

                      )
                    ],

                  ),
                  child: _ProductSlider(),
                );
              },),
            )
          ],
        ),
      )
    );
  }

  _ProductSlider() {
    return ListTile(
      title: Row(
        children: const [
          Text('Hamburguesa'),
          Padding(padding: EdgeInsets.only(left: 100,top: 20),child: Text('cantidad'))
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,),
      subtitle: Text('Precio'),
    );
  }

  void sumar1(BuildContext context) {

  }

  void delete1(BuildContext context) {

  }
}
