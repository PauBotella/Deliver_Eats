import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/food_type.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/providers/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';

class Restaurant {
  String address;
  String name;
  double minimumOrder;
  double rating;
  Future<FoodType> type;
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
        type: getType(json),
        rating: json['rating'].toDouble(),
        products: getProducts(json)
    );
  }

   static Future<FoodType> getType(json) async {
    final DocumentReference<Map<String, dynamic>> typeref = json['type'];
    DocumentSnapshot<Map<String, dynamic>> typeSnapshot = await typeref.get();
    final Map<String,dynamic> typeData = typeSnapshot.data()!;
    return FoodType.fromJson(typeData);
  }

  static Future<List<Product>> getProducts(json) async {
    List<Product> paco = [];
    print(json['products']);
    final List<dynamic> producJson = json['products'];
    final List<DocumentReference<Map<String, dynamic>>> productRef = producJson.map((docRef) => FirebaseFirestore.instance.doc(docRef.path)).toList();
    print("LISTA REERENCIAS" + productRef[0].toString());
    for(DocumentReference<Map<String, dynamic>> docRef in productRef) {
      DocumentSnapshot<Map<String, dynamic>> productSnapshot = await docRef.get();
      final Map<String, dynamic> productData = productSnapshot.data()!;
      paco.add(Product.fromJson(productData));
    }
    return paco;
  }
}