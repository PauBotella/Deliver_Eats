import 'dart:io';
import 'dart:math';

import 'package:deliver_eats/models/product.dart';
import 'package:deliver_eats/models/restaurant.dart';
import 'package:deliver_eats/providers/restaurant_provider.dart';
import 'package:deliver_eats/services/upload_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:deliver_eats/theme/app_theme.dart';
import 'package:deliver_eats/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import '../utils/dialog.dart';

class AddUpdateRestaurant extends StatefulWidget {
  const AddUpdateRestaurant({Key? key}) : super(key: key);

  @override
  State<AddUpdateRestaurant> createState() => _AddUpdateRestaurantState();
}

class _AddUpdateRestaurantState extends State<AddUpdateRestaurant> {
  @override
  void initState() {
    super.initState();
  }

  ImagePicker imagePicker = ImagePicker();
  XFile? _selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController addresController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Restaurante'),
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
                (_selectedImage != null) ? Container(
                  width: 200,
                  height: 200,
                  child: Image.file(
                    File(_selectedImage!.path), fit: BoxFit.cover,),
                ) : Container(),

                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _selectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
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
                  'Introduce el nombre del restaurante',
                  style: AppTheme.subtitleStyle,
                ),
                CustomInput(
                    isPasswordInput: false,
                    inputTxt: 'Nombre restaurante',
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
                    inputTxt: 'Nombre restaurante',
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
                    inputTxt: 'Nombre restaurante',
                    icon: Icons.abc,
                    controller: typeController),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: enabled ? () {
                    try {
                      _addRestaurant(File(_selectedImage!.path));
                    } catch (e) {
                      dialog('No puedes dejar la imagen vacia',context);
                    }

                  }: () => print('Desactivado'),
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
                      children: [Icon(Icons.add), Text('Añadir restaurante')],
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

  _addRestaurant(File image) async {
    enabled = false;
    setState(() {

    });
    String imageUrl = await uploadImage(image, '/restaurants');
    
    double randomRating = Random().nextDouble() * 5;
    if (randomRating < 1) {
      randomRating++;
    }

    String address = addresController.text;
    String name = nameController.text;
    String type = typeController.text;

    if(address.isEmpty || name.isEmpty || type.isEmpty || imageUrl.isEmpty) {
      enabled = true;
      setState(() {

      });
      dialog('no puedes dejar ningún campo vacio',context);
      return;
    }

    Future<List<Product>> list = Future.value([]);

    Restaurant restaurant = Restaurant(address: address,
        image: imageUrl,
        name: name,
        type: type,
        id: '',
        products: list,
        rating: randomRating);
    
    RestaurantProvider.addRestaurant(restaurant);
    
  }


}

