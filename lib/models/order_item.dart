import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/providers/order_provider.dart';
import 'package:deliver_eats/providers/product_provider.dart';

import 'orders.dart';

class OrderItem {
  int cantidad;
  Future<Orders> order;
  Future<Product> product;

  OrderItem({
    required this.cantidad,
    required this.order,
    required this.product,
  });

  static OrderItem fromJson(Map<String,dynamic> json,String id) {
    return OrderItem(cantidad: json['cantidad'], order: _getOrder(json['order_ID']), product: _getProduct(json['product_ID']));
  }

  static Future<Orders> _getOrder(DocumentReference<Map<String, dynamic>> ref) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    final Map<String, dynamic> orderData = snapshot.data()!;
    Orders user = Orders.fromJson(orderData,ref.id);
    return user;
  }

  static Future<Product> _getProduct(DocumentReference<Map<String, dynamic>> productRef) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await productRef.get();
    final Map<String, dynamic> productData = snapshot.data()!;
    Product product = Product.fromJson(productData,productRef.id);
    return product;
  }

  Future<Map<String, dynamic>> toMap() async {
    Orders order = await this.order;
    Product product = await this.product;
    return {
      'cantidad' : cantidad,
      'order_ID' : await OrderProvider.ordersRef.doc(order.id),
      'product_ID' : ProductProvider.productsRef.doc(product.id),

    };
  }

}