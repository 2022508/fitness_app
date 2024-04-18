// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isPswdVisible = true;
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);

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
                    backgroundImage: AssetImage('assets/images/pfp.jpg'),
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
