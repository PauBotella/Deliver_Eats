import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/cart.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:deliver_eats/services/auth_service.dart';

class CartProvider {
  final CollectionReference cartRef =
      FirebaseFirestore.instance.collection('cart');

  Future<List<Cart>> getCarts() {
    Future<UserF> user = UserProvider.getCurrentuser();
    List<Cart> carts = [];
    Future<List<Cart>> list =user.then((value) {
      DocumentReference doc = UserProvider.usersRef.doc(value.uid);
      cartRef.where('user_ID', isEqualTo: doc).get().then(
        (QuerySnapshot query) {
          for (var element in query.docs) {
            Cart cart = Cart.fromJson(element.data()! as Map<String, dynamic>,doc.id);
            carts.add(cart);
          }

        },
      );
      return carts;
    });
    return list;
  }

  updateCart(Cart cart) async{

    Map<String,dynamic> cartMap = await Cart.toMap(cart);

    try {
     await cartRef.doc(cart.id).update(cartMap);
     print('Carrito actualizado');
    } catch (e) {
      print('Error actualizando carrito'+ e.toString());
    }

  }

}