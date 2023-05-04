import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/order_item.dart';

class OrderItemProvider {
  static final CollectionReference order_itemRef = FirebaseFirestore.instance.collection('order_item');

  static addOrderItem(OrderItem item) async {
    try {
      await order_itemRef.add(await item.toMap());
      print('Producto Añadido al pedido');
    } catch (e) {
      print('Error añadiendo el producto al Pedido $e');
    }
  }
}
