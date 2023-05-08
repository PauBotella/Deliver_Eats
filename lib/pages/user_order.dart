import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/order_item.dart';
import 'package:deliver_eats/models/orders.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/order_item_provider.dart';
import 'package:deliver_eats/providers/order_provider.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class UserOrderPage extends StatefulWidget {
  UserOrderPage({Key? key}) : super(key: key);

  @override
  State<UserOrderPage> createState() => _UserOrderPageState();
}

class _UserOrderPageState extends State<UserOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registros de pedidos'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future:  OrderProvider.getOrdersList(),
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
                        if (itemSnapshot.hasData || ordersList.length == 0) {
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

    if(user.uid == currentUser.uid) {

      return Padding(
        padding: EdgeInsets.all(20),
        child: Column(
            children: [
              Container(
                color: AppTheme.widgetColor,
                width: double.infinity,
                height: size.height-530,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'En la fecha ${order.date}',
                      style: AppTheme.titleStyle,
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
                        Text('${await _getTotalPrice(itemList)}${AppTheme.euroTxt}',
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
    return SizedBox(height: 0,width: 0,);


  }
}

_getTotalPrice(List<OrderItem> itemList) async {
  double price = 0.0;

  for (OrderItem item in itemList) {
    Product p = await item.product;
    price += p.price;
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
        p.name + " ",
        style: AppTheme.subtitleStyle,
      ),
      Text(p.price.toString() + AppTheme.euroTxt,style: AppTheme.priceStyle,),
    ]);
    list.add(txt);
    list.add(Divider(
      color: Colors.amber,
      thickness: 2,
    ));
  }

  return list;
}