import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';

class Restaurant {
  String address;
  String name;
  double minimumOrder;
  double rating;
  String type;
  String image;
  Future<List<Product>> products;


  Restaurant({
    required this.address,
    required this.image,
    required this.minimumOrder,
    required this.name,
    required this.type,
    required this.products,
    required this.rating

  });

  static Restaurant fromJson(Map<String, dynamic> json) {
    return Restaurant(
        address: json['address'],
        image: json['image'],
        minimumOrder: json['minimum_order'].toDouble(),
        name: json['name'],
        type: json['type'],
        rating: json['rating'].toDouble(),
        products: getProducts(json)
    );
  }

  static Future<List<Product>> getProducts(Map<String, dynamic> json) async {
    List<Product> paco = [];
    final List<dynamic> producJson = json['products'];
    final List<DocumentReference<Map<String, dynamic>>> productRef = producJson.map((docRef) => FirebaseFirestore.instance.doc(docRef.path)).toList();
    for(DocumentReference<Map<String, dynamic>> docRef in productRef) {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot = await docRef.get();
      final Map<String, dynamic> productData = productSnapshot.data()!;
      paco.add(Product.fromJson(productData,docRef.id));
    }
    return paco;
  }
}