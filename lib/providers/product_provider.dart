import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductProvider {
  static final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
  Future<List<Product>> getListFromRestaurants(List<DocumentReference> list) async {
    List<Product> products = [];
    for (int i = 0; i < list.length; i++) {
      DocumentReference<Map<String, dynamic>> reference = list[i] as DocumentReference<Map<String, dynamic>>;
      DocumentSnapshot<Map<String, dynamic>> typeSnapshot = await reference.get();
      final Map<String, dynamic> typeData = typeSnapshot.data()!;
      Product product = Product.fromJson(typeData, reference.id);
      products.add(product);
    }
    return await Future.value(products);
  }
}
