import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/providers/restaurant_provider.dart';

class Restaurant {
  String address;
  String name;
  String id;
  double rating;
  String type;
  String image;
  Future<List<Product>> products;


  Restaurant({
    required this.address,
    required this.image,
    required this.name,
    required this.type,
    required this.id,
    required this.products,
    required this.rating

  });

  static Restaurant fromJson(Map<String, dynamic> json, String id) {
    return Restaurant(
        address: json['address'],
        image: json['image'],
        name: json['name'],
        type: json['type'],
        id: id,
        rating: json['rating'].toDouble(),
        products: getProducts(json)
    );
  }

  static Future<Map<String, dynamic>> toMap(Restaurant restaurant) async {

    List<Product> products = await restaurant.products;

    List<DocumentReference> refList = [];

    products.forEach((element) {
      refList.add(RestaurantProvider.restaurantRef.doc(element.id));
    });

    return {
      'address' : restaurant.address,
      'image' : restaurant.image,
      'name' : restaurant.name,
      'type' : restaurant.type,
      'rating' : restaurant.rating,
      'products' : refList,

    };
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