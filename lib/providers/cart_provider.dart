import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/cart.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/user_provider.dart';

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
            Cart cart = Cart.fromJson(element.data()! as Map<String, dynamic>,element.id);
            carts.add(cart);
          }

        },
      );
      return carts;
    });
    return list;
  }

  updateCart(Cart cart) async{

    Map<String,dynamic> cartMap = await cart.toMap();

    try {
     await cartRef.doc(cart.id).update(cartMap);
     print('Carrito actualizado');
    } catch (e) {
      print('Error actualizando carrito$e');
    }

  }

  deleteCart(String id) async {
    try {
      await cartRef.doc(id).delete();
      print('Carrito borrado');
    } catch (e) {
      print('Error borrando carrito $e');
    }
  }

}
