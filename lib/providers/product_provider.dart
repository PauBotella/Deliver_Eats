import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductProvider {
  Future<List<Product>> getListFromRestaurants(List<DocumentReference> list) async {
    List<Product> products = [];
    for (int i = 0; i < list.length; i++) {
      DocumentReference<Map<String, dynamic>> reference = list[i] as DocumentReference<Map<String, dynamic>>;
      DocumentSnapshot<Map<String, dynamic>> typeSnapshot = await reference.get();
      final Map<String, dynamic> typeData = typeSnapshot.data()!;
      Product product = Product(
          name: typeData['name'],
          description: typeData['description'],
          image: typeData['image'],
          price: typeData['price'],
          rating: typeData['rating']);
      products.add(product);
    }
    print('alberto');
    return await Future.value(products);
  }
}
