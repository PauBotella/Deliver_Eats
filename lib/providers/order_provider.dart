import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/orders.dart';

class OrderProvider {
  static final CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');


  static Stream<QuerySnapshot<Map<String,dynamic>>>getOrders() {
    Stream<QuerySnapshot<Map<String,dynamic>>> stream = ordersRef.snapshots() as Stream<QuerySnapshot<Map<String,dynamic>>>;
    return stream;
  }

  static addOrder(Orders order) async {
    try {
      DocumentReference<Map<String,dynamic>> ref = await ordersRef.add(await order.toMap()) as DocumentReference<Map<String,dynamic>> ;
      print('Pedido Añadido');
      return ref;
    } catch (e) {
      print('Error añadiendo Pedido $e');
    }
  }
}
