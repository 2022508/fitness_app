// ignore_for_file: unused_local_variable, prefer_const_declarations

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraServices {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  void saveImage(XFile img) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File convert = File(img.path);
    final String fileName = "pfp.jpg";
    final File localImage = await convert.copy('$path/$fileName');
  }
}
