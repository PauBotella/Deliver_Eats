import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/orders.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/user_provider.dart';

class OrderProvider {
  static final CollectionReference ordersRef = FirebaseFirestore.instance.collection('orders');


  static Stream<QuerySnapshot<Map<String,dynamic>>>getOrders() {
    Stream<QuerySnapshot<Map<String,dynamic>>> stream = ordersRef.snapshots() as Stream<QuerySnapshot<Map<String,dynamic>>>;
    return stream;
  }

  static Future<List<Orders>> getOrdersList() async {
    List<Orders> list = [];
    UserF user = await UserProvider.getCurrentuser();
    DocumentReference doc = UserProvider.usersRef.doc(user.uid);
    QuerySnapshot snapshot = await ordersRef.where('user_ID',isEqualTo: doc).get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    docs.forEach((document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      list.add(Orders.fromJson(data, document.id));
    });

    return list;

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
