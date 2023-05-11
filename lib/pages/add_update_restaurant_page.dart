import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:deliver_eats/models/user.dart';
import 'package:deliver_eats/providers/restaurant_provider.dart';
import 'package:deliver_eats/providers/user_provider.dart';
import 'package:deliver_eats/services/auth_service.dart';
import 'package:deliver_eats/services/upload_image.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/dialog.dart';
import '../utils/utils.dart';

class AddUpdateRestaurant extends StatefulWidget {
  const AddUpdateRestaurant({Key? key}) : super(key: key);

  @override
  State<AddUpdateRestaurant> createState() => _AddUpdateRestaurantState();
}

class _AddUpdateRestaurantState extends State<AddUpdateRestaurant> {
  ImagePicker imagePicker = ImagePicker();
  XFile? _selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController addresController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments! as List<dynamic>;

    Restaurant? restaurant = arguments[0] as Restaurant?;
    bool update = arguments[1] as bool;

    return Scaffold(
      appBar: AppBar(
        title: update
            ? Text('Actualizar Restaurante')
            : Text('Añadir Restaurante'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Introduce la imagen del restaurante',
                  style: AppTheme.subtitleStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                //Mostrar imagen
                (_selectedImage != null)
                    ? Container(
                        width: 200,
                        height: 200,
                        child: Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : update
                        ? Container(
                            width: 200,
                            height: 200,
                            child: Image.network(
                              restaurant!.image,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(),

                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _enabled
                      ? () async {
                          _selectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          setState(() {});
                        }
                      : null,
                  child: Icon(Icons.photo),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 3,
                      minimumSize: const Size(300, 50),
                      maximumSize: const Size(300, 50)),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Introduce el nombre del restaurante',
                  style: AppTheme.subtitleStyle,
                ),
                CustomInput(
                    isPasswordInput: false,
                    inputTxt: update ? restaurant!.name : 'Ej: pekin muralla',
                    icon: Icons.account_circle_outlined,
                    controller: nameController),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Introduce la dirección del restaurante',
                  style: AppTheme.subtitleStyle,
                ),
                CustomInput(
                    isPasswordInput: false,
                    inputTxt:
                        update ? restaurant!.address : 'Ej: calle chabolas 12',
                    icon: Icons.abc,
                    controller: addresController),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Introduce el tipo de comida del restaurante',
                  style: AppTheme.subtitleStyle,
                ),
                CustomInput(
                    isPasswordInput: false,
                    inputTxt: update ? restaurant!.type : 'Ej: china',
                    icon: Icons.abc,
                    controller: typeController),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: _enabled
                      ? () async {
                          try {
                            if (update && _selectedImage == null) {
                              _selectedImage =
                                  await getImageByURL(restaurant!.image);
                              setState(() {});
                            }
                            _addRestaurant(
                                File(_selectedImage!.path), update, restaurant);
                          } catch (e) {
                            diaglogResult('No puedes dejar la imagen vacia',
                                context, AppTheme.failAnimation, '');
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      elevation: 3,
                      minimumSize: const Size(300, 50),
                      maximumSize: const Size(300, 50)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 55),
                    child: Row(
                      children: [
                        update ? Icon(Icons.update) : Icon(Icons.add),
                        update
                            ? Text(' Actualizar Restaurante')
                            : Text(' Añadir restaurante')
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _addRestaurant(File image, bool update, Restaurant? restaurant) async {
    try {
      _enabled = false;
      setState(() {});
      String imageUrl = await uploadImage(image, '/restaurants');

      double randomRating = Random().nextDouble() * 5;
      if (randomRating < 1) {
        randomRating++;
      }

      String address = addresController.text;
      String name = nameController.text;
      String type = typeController.text;

      if (address.isEmpty || name.isEmpty || type.isEmpty || imageUrl.isEmpty) {
        if (update) {
          if (address.isEmpty) address = restaurant!.address;
          if (name.isEmpty) name = restaurant!.name;
          if (type.isEmpty) type = restaurant!.type;
        } else {
          throw Exception('no puedes dejar ningún campo vacio');
        }
      }

      Future<List<Product>> list = Future.value([]);

      Restaurant newRestaurant = Restaurant(
          address: address,
          image: imageUrl,
          name: name,
          type: type,
          id: '',
          products: list,
          rating: randomRating);

      QuerySnapshot<Object?> comprobar = await RestaurantProvider.restaurantRef
          .where('name', isEqualTo: newRestaurant.name)
          .get();

      if (comprobar.docs.isEmpty || update) {
        if (update) {
          newRestaurant.products = restaurant!.products;
          newRestaurant.id = restaurant.id;
          await _updateRestaurant(newRestaurant);
        } else {
          await RestaurantProvider.addRestaurant(newRestaurant);
          await _createUserFromRestaurant(newRestaurant);
        }

        _enabled = true;
        setState(() {});
        diaglogResult(
            update
                ? 'Restaurante actualizado con éxito'
                : 'Restaurante creado con éxito',
            context,
            AppTheme.checkAnimation,
            'home');
      } else {
        throw Exception('El nombre de ese restaurante ya existe');
      }
    } catch (e) {
      _enabled = true;
      setState(() {});
      diaglogResult(
          e.toString().split(":")[1], context, AppTheme.failAnimation, '');
    }
  }

  _updateRestaurant(Restaurant restaurant) async {
    await RestaurantProvider.updateRestaurant(restaurant);
  }

  _createUserFromRestaurant(Restaurant restaurant) async {
    QuerySnapshot<Object?> comprobar = await RestaurantProvider.restaurantRef
        .where('name', isEqualTo: restaurant.name)
        .get();

    String id = comprobar.docs[0].id;
    String email =
        restaurant.name.replaceAll(' ', '').toLowerCase() + "@gmail.com";
    String password = restaurant.name.replaceAll(' ', '').toLowerCase();

    if (password.length < 6) {
      password += "123456";
    }

    print('password');

    await FbAuth()
        .createUserWithEmailAndPassword(email: email, password: password);

    UserF encargado = UserF(
        email: email,
        username: email.split("@")[0],
        role: 'encargado',
        uid: '',
        restaurant: Future.value(Restaurant.fromJson(
            comprobar.docs[0].data() as Map<String, dynamic>, id)));

    await UserProvider.addUser(encargado);

    _enabled = true;
    setState(() {});
  }
}
