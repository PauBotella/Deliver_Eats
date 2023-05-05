import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/restaurant.dart';

class RestaurantProvider {
  static final CollectionReference restaurantRef = FirebaseFirestore.instance.collection('restaurants');
  Stream<QuerySnapshot<Map<String,dynamic>>>getRestaurants() {
    Stream<QuerySnapshot<Map<String,dynamic>>> stream = restaurantRef.snapshots() as Stream<QuerySnapshot<Map<String,dynamic>>>;
    return stream;
  }

  static updateRestaurant(Restaurant restaurant) async{

    Map<String,dynamic> cartMap = await restaurant.toMap();

    try {
      await restaurantRef.doc(restaurant.id).update(cartMap);
      print('Restaurante actualizado');
    } catch (e) {
      print('Error actualizando Restaurante $e');
    }

  }

  static addRestaurant(Restaurant restaurant) async{

    try {
      await restaurantRef.add(await restaurant.toMap());
      print('Restaurante Añadido');
    } catch (e) {
      print('Error añadiendo Restaurante $e');
    }

  }

  static deleteRestaurant(String id) async {
    try {
      await restaurantRef.doc(id).delete();
      print('Restaurante borrado');
    } catch (e) {
      print('Error borrando Restaurante $e');
    }
  }

}