import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/user.dart';

class Cart {

  int cantidad;
  Future<UserF> user;
  Future<Product> product;

  Cart({
    required this.cantidad,
    required this.user,
    required this.product,
  });

  static Cart fromJson(Map<String,dynamic> json) {
    return Cart(
        cantidad: json['cantidad'],
        user: _getUser(json['user_ID']),
        product: _getProduct(json['product_ID'])
    );
  }

  static Future<UserF> _getUser(DocumentReference<Map<String, dynamic>> userRef) {
    Future<UserF> user =
    userRef.get().then((value) {
      Map<String,dynamic> userMap = value.data()!;
      return UserF.fromJson(userMap,userRef.id);
    }
    );
    return user;
  }

  static Future<Product> _getProduct(DocumentReference<Map<String, dynamic>> productRef) async{
    DocumentSnapshot<Map<String, dynamic>> snapshot = await productRef.get();
    final Map<String, dynamic> productData = snapshot.data()!;
    Product product = Product.fromJson(productData);
    return product;
  }
}