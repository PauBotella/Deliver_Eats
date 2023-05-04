import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImage(File image,String path) async{
  final name = image.path.split('/')[0] +"-"+ Uuid().v4();
  
  Reference ref = storage.ref().child(path).child(name);

  final UploadTask uploadTask = ref.putFile(image);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  final String url = await snapshot.ref.getDownloadURL();

  return url;

}