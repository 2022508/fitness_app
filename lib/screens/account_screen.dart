// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations

import 'dart:io';

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

  @override
  void initState() {
    super.initState();
    loadImage();
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
                  CircleAvatar(
                    radius: 100,
                    // backgroundImage: AssetImage('assets/images/pfp.jpg'),
                    backgroundImage: Image.file(File(image!.path)).image,
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
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyTextField(
                  hintText: "John Doe",
                  prefixIcon: Icon(Icons.account_circle_sharp),
                  readOnly: true),
              MyTextField(
                  hintText: "email@gmail.com",
                  prefixIcon: Icon(Icons.email),
                  readOnly: true),
              MyPasswordTextField(hintText: "Old password"),
              MyPasswordTextField(hintText: "New password"),
              SizedBox(height: 20),
              MyElevatedButton(text: "Make changes")
            ],
          )),
        ),
      ),
    ));
  }
}
