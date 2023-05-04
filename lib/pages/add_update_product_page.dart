import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:deliver_eats/providers/product_provider.dart';
import 'package:deliver_eats/providers/restaurant_provider.dart';
import 'package:deliver_eats/services/upload_image.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/dialog.dart';

class AddUpdateProduct extends StatefulWidget {
  const AddUpdateProduct({Key? key}) : super(key: key);

  @override
  State<AddUpdateProduct> createState() => _AddUpdateProductState();
}

class _AddUpdateProductState extends State<AddUpdateProduct> {
  @override
  void initState() {
    super.initState();
  }

  ImagePicker imagePicker = ImagePicker();
  XFile? _selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Producto'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Introduce la imagen del Producto',
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
                    : Container(),

                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _selectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    setState(() {});
                  },
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
                  'Introduce el nombre del Producto',
                  style: AppTheme.subtitleStyle,
                ),
                CustomInput(
                    isPasswordInput: false,
                    inputTxt: 'Ej: Pollo al limón',
                    icon: Icons.account_circle_outlined,
                    controller: nameController),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Introduce la descripción del producto',
                  style: AppTheme.subtitleStyle,
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  height: 5 * 24.0,
                  child: TextField(
                    maxLines: 5,
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Un plato muy rico',
                      hintStyle: TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Introduce el precio del producto',
                  style: AppTheme.subtitleStyle,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: Ink(
                          child: Icon(
                            Icons.numbers,
                            color: AppTheme.widgetColor,
                          ),
                        ),
                        label: Text('Ej 15.80')),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: enabled
                      ? () {
                          try {
                            _addProduct(File(_selectedImage!.path));
                          } catch (e) {
                            diaglogResult(false, 'No puedes dejar la imagen vacia', context);
                          }
                        }
                      : () => print('Desactivado'),
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
                      children: [Icon(Icons.add), Text('Añadir producto')],
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

  _addProduct(File image) async {
    bool completed = false;
    try {
      enabled = false;
      setState(() {});
      String imageUrl = await uploadImage(image, '/products');

      double randomRating = Random().nextDouble() * 5;
      if (randomRating < 1) {
        randomRating++;
      }

      String description = descriptionController.text;
      String name = nameController.text;
      String priceTxt = priceController.text;

      if (description.isEmpty || name.isEmpty || priceTxt.isEmpty || imageUrl.isEmpty) {
        enabled = true;
        setState(() {});
        throw Exception('No puedes dejar ningún campo vacio');
      }
      double price = 0.0;
      try {
        price = double.parse(priceTxt);
      } catch (e) {
        throw Exception("Introduce un precio válido");
      }

      Product product = Product(
          image: imageUrl,
          name: name,
          price: price,
          description: description,
          id: '',
          rating: randomRating);

      QuerySnapshot<Object?> comprobar = await ProductProvider.productsRef
          .where('name', isEqualTo: product.name)
          .get();

      if (comprobar.docs.isEmpty) {
        await ProductProvider.addProduct(product);
        await _addProductToRestaurant(product.name);
      } else {
        completed = false;
        throw Exception("Ese nombre del producto ya existe");
      }

      enabled = true;
      setState(() {});
      completed = true;
      diaglogResult(completed, 'Producto añadido con exito', context);
    } catch (e) {
      diaglogResult(completed, e.toString().split(":")[1], context);
    }

  }

  _addProductToRestaurant(String name) async {

    QuerySnapshot<Object?> comprobar = await ProductProvider.productsRef
        .where('name', isEqualTo: name)
        .get();

    Restaurant restaurant =
        ModalRoute.of(context)!.settings.arguments! as Restaurant;
    List<Product> list = await restaurant.products;
    list.add(Product.fromJson(comprobar.docs[0].data() as Map<String,dynamic>, comprobar.docs[0].id));
    restaurant.products = Future.value(list);
    await RestaurantProvider.updateRestaurant(restaurant);
  }
}