
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

formatNumber(double number) {
  if(number < 100) {
    return NumberFormat("#,#0.0", "es_ES").format(number);
  } else {
    return NumberFormat("##0.0", "es_ES").format(number);
  }

}

getImageByURL(String url) async {
  File restaurantImg = await DefaultCacheManager().getSingleFile(url);
  XFile imgFile = await XFile(restaurantImg.path);
  return imgFile;
}