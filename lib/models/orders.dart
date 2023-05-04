import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/order_provider.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Orders {
  String date;
  Future<UserF> user;
  String id;
  double totalPrice;

  Orders({required this.date, required this.user, required this.id,required this.totalPrice});

  static Orders fromJson(Map<String, dynamic> json, String id) {
    return Orders(date: json['date'], user: _getUser(json['user_ID']),id: id,totalPrice: json['totalPrice']);
  }

  static Future<UserF> _getUser(DocumentReference<Map<String, dynamic>> ref) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
    final Map<String, dynamic> productData = snapshot.data()!;
    UserF user = UserF.fromJson(productData, ref.id);
    return user;
  }

  Future<Map<String, dynamic>> toMap() async {
    UserF user = await this.user;

    return {
      'date': date,
      'totalPrice':totalPrice,
      'user_ID': UserProvider.usersRef.doc(await user.uid),
    };
  }
}
