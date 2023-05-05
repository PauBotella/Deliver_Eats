import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/order_item.dart';

import 'order_provider.dart';

class OrderItemProvider {
  static final CollectionReference order_itemRef = FirebaseFirestore.instance.collection('order_item');

  static Stream<QuerySnapshot<Map<String,dynamic>>>getOrder_item(String orderId) {
    DocumentReference ref = OrderProvider.ordersRef.doc(orderId);
    Stream<QuerySnapshot<Map<String,dynamic>>> stream = order_itemRef.where('order_ID',isEqualTo: ref).snapshots() as Stream<QuerySnapshot<Map<String,dynamic>>>;
    return stream;
  }

  static addOrderItem(OrderItem item) async {
    try {
      await order_itemRef.add(await item.toMap());
      print('Producto Añadido al pedido');
    } catch (e) {
      print('Error añadiendo el producto al Pedido $e');
    }
  }
}
