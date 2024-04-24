// ignore_for_file: unused_local_variable, prefer_const_declarations

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// https://www.youtube.com/watch?v=fJtFDrjEvE8
// used to help create the camera services, other uses from the video are in other files aswell

class CameraServices {
  Future<void> saveImage(XFile img, String email) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File convert = File(img.path);
    final File localImage = await convert.copy('$path/$email');
  }
}
