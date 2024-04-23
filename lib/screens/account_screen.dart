// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, unused_local_variable

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/services/camera_services.dart';
import 'package:fitness_app/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isPswdVisible = true;
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);
  bool isImageLoaded = false;
  bool isUserLoaded = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final CameraServices cameraServices = CameraServices();

  XFile? image;

  Future<void> loadImage() async {
    Map<String, dynamic> _getData =
        await DatabaseServices.getUsersDetailsByEmail(
            FirebaseAuth.instance.currentUser!.email!);

    final String path = _getData['path'];
    final String fileName = _getData['email'];

    if (File('$path/$fileName').existsSync()) {
      setState(() {
        isImageLoaded = true;
        image = XFile('$path/$fileName');
      });
    }
  }

  void modalBottomSheet(Widget widget, String newTitle, [Color? color]) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: color ?? Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
              padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: widget);
        });
      },
    );
  }

  final ImagePicker picker = ImagePicker();

  Future<void> getPhoto(ImageSource type) async {
    final XFile? pickedImage = await picker.pickImage(source: type);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
      cameraServices.saveImage(
          pickedImage, FirebaseAuth.instance.currentUser!.email!);
    }
  }

  void pfpModalBottomSheet() {
    modalBottomSheet(
      Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {
                getPhoto(ImageSource.camera);
              },
              icon: Icon(
                Icons.camera_alt,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {
                getPhoto(ImageSource.gallery);
              },
              icon: Icon(Icons.photo, size: 100, color: Colors.white),
            ),
          )
        ],
      ),
      "Profile Picture",
      Colors.black.withOpacity(0.5),
    );
  }

  Future<void> getUser() async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      user = await FirebaseAuth.instance.currentUser;

      setState(() {
        isUserLoaded = true;
        nameController.text = user!.displayName!;
        emailController.text = user.email!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadImage();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    // loadImage();
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Column(
            children: [
              if (isImageLoaded)
                Stack(
                  children: [
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: image == null
                          ? AssetImage('assets/images/pfp.jpg')
                          : Image.file(File(image!.path)).image,
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_a_photo,
                          color: Colors.red.withOpacity(0.7),
                          size: 30,
                        ),
                        onPressed: pfpModalBottomSheet,
                      ),
                    ),
                  ],
                )
              else
                Center(child: CircularProgressIndicator()),
              SizedBox(height: 20),
              if (isUserLoaded)
                Column(
                  children: [
                    MyTextField(
                        controller: nameController,
                        hintText: "Name",
                        prefixIcon: Icon(Icons.account_circle_sharp),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.upload),
                          onPressed: () {},
                        )),
                    MyTextField(
                        controller: emailController,
                        hintText: "email@gmail.com",
                        prefixIcon: Icon(Icons.email)),
                    MyPasswordTextField(
                      hintText: "Old password",
                      color: Colors.black,
                      prefixIcon: Icon(Icons.lock),
                    ),
                    MyPasswordTextField(
                      hintText: "New password",
                      color: Colors.black,
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.upload),
                        onPressed: () {},
                      ),
                    ),
                    // SizedBox(height: 20),
                    // MyElevatedButton(text: "Make changes")
                  ],
                )
              else
                Center(child: CircularProgressIndicator()),
            ],
          )),
        ),
      ),
    ));
  }
}
