import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/order_item.dart';
import 'package:deliver_eats/models/orders.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/order_item_provider.dart';
import 'package:deliver_eats/providers/order_provider.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:deliver_eats/utils/utils.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RestaurantOrderPage extends StatefulWidget {
  RestaurantOrderPage({Key? key}) : super(key: key);

  @override
  State<RestaurantOrderPage> createState() => _RestaurantOrderPageState();
}

class _RestaurantOrderPageState extends State<RestaurantOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos Restaurantes'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: OrderProvider.getOrdersList(),
          builder:
              (BuildContext context, AsyncSnapshot<dynamic> orderSnapshot) {
            if (orderSnapshot.hasData) {
              List<Orders> ordersList = orderSnapshot.data!;

              return ListView.builder(
                itemCount: ordersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 350,
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
                              FutureBuilder(
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
    final size = MediaQuery.of(context).size;
    UserF user = await order.user;
    UserF currentUser = await UserProvider.getCurrentuser();
    Restaurant restaurant = await currentUser.restaurant!;

    List<Widget> list = await _getProducts(itemList, await restaurant.products);

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            color: AppTheme.widgetColor,
            width: double.infinity,
            height: size.height - 510,
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
                  child: ListView(children: list),
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
    price += p.price * item.quantity;
  }

  return price;
}

Future<List<Widget>> _getProducts(
    List<OrderItem> itemList, List<Product> restaurantProducts) async {
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
        '[${item.quantity}] ${p.name}',
        style: AppTheme.subtitleStyle,
      ),
      Text(
        '${formatNumber(p.price * item.quantity)}' + AppTheme.euroTxt,
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
