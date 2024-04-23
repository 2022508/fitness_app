// ignore_for_file: unused_local_variable, prefer_const_declarations

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraServices {
  Future<void> saveImage(XFile img, String email) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File convert = File(img.path);
    final File localImage = await convert.copy('$path/$email');
  }
}
