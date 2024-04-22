// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, unused_local_variable

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isPswdVisible = true;
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  XFile? image;

  void loadImage() async {
    final String fileName = "pfp.jpg";
    final String path = (await getApplicationDocumentsDirectory()).path;

    if (File('$path/$fileName').existsSync()) {
      setState(() {
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

  void getPhoto(ImageSource type) async {
    final XFile? pickedImage = await picker.pickImage(source: type);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
      saveImage(pickedImage);
    }
  }

  void saveImage(XFile img) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    File convert = File(img.path);
    final String fileName = "pfp.jpg";
    final File localImage = await convert.copy('$path/$fileName');
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

  void getUser() async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      user = await FirebaseAuth.instance.currentUser;

      setState(() {
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
              // IconButton(
              //   style: ButtonStyle(),
              //   icon: CircleAvatar(
              //     radius: 100,
              //     backgroundImage: AssetImage('assets/images/pfp.jpg'),
              //   ),
              //   onPressed: () {},
              // ),
              SizedBox(height: 10),
              Stack(
                children: [
                  // CircleAvatar(
                  //     radius: 100,
                  //     //   // backgroundImage: AssetImage('assets/images/pfp.jpg'),

                  //     backgroundImage: Image.file(File(image!.path)).image),
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
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
              MyElevatedButton(text: "Make changes")
            ],
          )),
        ),
      ),
    ));
  }
}
