import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/order_item.dart';
import 'package:deliver_eats/models/orders.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/order_item_provider.dart';
import 'package:deliver_eats/providers/order_provider.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/utils.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registros de pedidos'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: OrderProvider.getOrders(),
          builder:
              (BuildContext context, AsyncSnapshot<dynamic> orderSnapshot) {
            if (orderSnapshot.hasData) {
              print(orderSnapshot.data);

              List<Orders> ordersList = orderSnapshot.data!.docs
                  .map<Orders>((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                Orders order = Orders.fromJson(data, document.id);
                return order;
              }).toList();

              return ListView.builder(
                itemCount: ordersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 350,
                    // Establece una altura determinada para cada elemento de la lista
                    child: StreamBuilder(
                      stream:
                          OrderItemProvider.getOrder_item(ordersList[index].id),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> itemSnapshot) {
                        if (itemSnapshot.hasData) {
                          List<OrderItem> itemList = itemSnapshot.data!.docs
                              .map<OrderItem>((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            OrderItem restaurant =
                                OrderItem.fromJson(data, document.id);
                            return restaurant;
                          }).toList();

                          return Column(
                            children: [
                              Expanded(
                                child: FutureBuilder(
                                  future: _orderContainer(
                                      itemList, ordersList[index]),
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
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ));
  }

  Future<Widget> _orderContainer(List<OrderItem> itemList, Orders order) async {
    UserF user = await order.user;

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            color: AppTheme.widgetColor,
            width: double.infinity,
            height: 300,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Pedido de ${user.username}',
                  style: AppTheme.titleStyle,
                ),
                Text(
                  'En la fecha ${order.date}',
                  style: AppTheme.subtitleStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 158,
                  child: ListView(children: await _getProducts(itemList)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Precio total: ',
                      style: AppTheme.subtitleStyle,
                    ),
                    Text(
                        '${formatNumber(await _getTotalPrice(itemList))}' +
                            '${AppTheme.euroTxt}',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

_getTotalPrice(List<OrderItem> itemList) async {
  double price = 0.0;

  for (OrderItem item in itemList) {
    Product p = await item.product;
    price += p.price * item.cantidad;
  }

  return price;
}

Future<List<Widget>> _getProducts(List<OrderItem> itemList) async {
  List<Widget> list = [
    Divider(
      color: Colors.amber,
      thickness: 2,
    )
  ];

  for (OrderItem item in itemList) {
    Product p = await item.product;
    Widget txt = Row(children: [
      Text(
        '[${item.cantidad}] ${p.name} ',
        style: AppTheme.subtitleStyle,
      ),
      Text(
        '${formatNumber(p.price * item.cantidad)}' + AppTheme.euroTxt,
        style: AppTheme.priceStyle,
      ),
    ]);
    list.add(txt);
    list.add(Divider(
      color: Colors.amber,
      thickness: 2,
    ));
  }

  return list;
}
