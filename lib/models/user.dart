
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:deliver_eats/providers/restaurant_provider.dart';

class UserF {
  String email, username;
  String role,id;
  Future<Restaurant>? restaurant;

  UserF({required this.email, required this.username, required this.role,required this.id,this.restaurant});

  Future<Map<String, dynamic>> toMap() async{


      if(restaurant == null) {
        return {
          'email': email,
          'username': username,
          'role_ID': role
        };
      } else {
        return {
          'email': email,
          'username': username,
          'role_ID': role,
          'restaurant': RestaurantProvider.restaurantRef.doc( (await restaurant)!.id )
        };
      }

  }

  factory UserF.fromJson(Map<String,dynamic> json,String id) {

    try {
      return UserF(
          email: json['email'],
          username: json['username'],
          role: json['role_ID'],
          restaurant: _getProduct(json['restaurant']),
          id: id
      );
    } catch (e) {
      return UserF(
          email: json['email'],
          username: json['username'],
          role: json['role_ID'],
          id: id
      );
    }


  }

  static Future<Restaurant> _getProduct(DocumentReference<Map<String, dynamic>> restauranttRef) async{

    DocumentSnapshot<Map<String, dynamic>>snapshot  = await restauranttRef.get();
    final Map<String, dynamic> restaurantData = snapshot.data()!;
    Restaurant restaurant = Restaurant.fromJson(restaurantData,restauranttRef.id);
    return restaurant;
  }
}
