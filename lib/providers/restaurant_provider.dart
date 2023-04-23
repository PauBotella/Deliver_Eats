import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantProvider {
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('restaurants');
  Stream<QuerySnapshot<Map<String,dynamic>>>getRestaurants() {
    Stream<QuerySnapshot<Map<String,dynamic>>> stream = _collectionRef.snapshots() as Stream<QuerySnapshot<Map<String,dynamic>>>;
    return stream;
  }

}