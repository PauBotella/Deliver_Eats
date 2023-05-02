import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';

class ProductProvider {
  static final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');
  Future<List<Product>> getListFromRestaurants(List<DocumentReference> list) async {
    List<Product> products = [];
    for (int i = 0; i < list.length; i++) {
      DocumentReference<Map<String, dynamic>> reference = list[i] as DocumentReference<Map<String, dynamic>>;
      DocumentSnapshot<Map<String, dynamic>> productSnapshot = await reference.get();
      final Map<String, dynamic> typeData = productSnapshot.data()!;
      Product product = Product.fromJson(typeData, reference.id);
      products.add(product);
    }
    return await Future.value(products);
  }

  static void deleteProduct(String id) async {
    try {
      await productsRef.doc(id).delete();
      print('Producto borrado');
    } catch (e) {
      print('Error borrando Producto $e');
    }
  }

  static addProduct(Product product) async {
    try {
      await productsRef.add(await product.toMap());
    print('Restaurante Añadido');
    } catch (e) {
    print('Error añadiendo Restaurante $e');
    }
  }
}
