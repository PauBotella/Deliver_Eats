import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CrudRestaurantPage extends StatefulWidget {
  const CrudRestaurantPage({Key? key}) : super(key: key);

  @override
  State<CrudRestaurantPage> createState() => _CrudRestaurantPageState();
}

class _CrudRestaurantPageState extends State<CrudRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        onPressed: () {},
        child: const Icon(Icons.add_card),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: DrawerMotion(),
                      children: [
                        SlidableAction(
                          key: UniqueKey(),
                          autoClose: false,
                          onPressed: (BuildContext context) => print("borrar"),
                          backgroundColor: Colors.red,
                          icon: Icons.delete_forever,
                          label: 'Borrar',
                        )
                      ],
                    ),
                    child: ListTile(title: Text('hola'),)
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
