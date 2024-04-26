// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/services/camera_services.dart';
import 'package:fitness_app/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';

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
  final ImagePicker picker = ImagePicker();

  Future<void> loadImage() async {
    Map<String, dynamic> getData =
        await DatabaseServices.getUsersDetailsByEmail(
            FirebaseAuth.instance.currentUser!.email!);
    try {
      final String path = getData['path'];
      final String fileName = getData['email'];
      if (File('$path/$fileName').existsSync()) {
        setState(() {
          isImageLoaded = true;
          image = XFile('$path/$fileName');
        });
      }
    } catch (e) {
      log(e.toString());
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

  void pfpModalBottomSheet() {
    modalBottomSheet(
      Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () async {
                image =
                    await cameraServices.getPhotoLoggedIn(ImageSource.camera);
                setState(() {});
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
              onPressed: () async {
                image =
                    await cameraServices.getPhotoLoggedIn(ImageSource.gallery);
                setState(() {});
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
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;

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
                          icon: Icon(Icons.upload, color: Colors.red, size: 30),
                          onPressed: () {},
                        )),
                    MyTextField(
                      controller: emailController,
                      hintText: "email@gmail.com",
                      prefixIcon: Icon(Icons.email),
                      readOnly: true,
                    ),
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
                        icon: Icon(Icons.upload, color: Colors.red, size: 30),
                        onPressed: () {},
                      ),
                    ),
                    MyElevatedButton(
                        text: "Sign out",
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        })
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
