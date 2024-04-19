// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/screens/navbar_screen.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  String title = "FITNESS APP";
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);
  bool isPswdVisible = true;
  int isModalActive = 0;

  void modalBottomSheet(Widget widget, String newTitle, [Color? color]) {
    showModalBottomSheet(
      // https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
      isScrollControlled: true,
      backgroundColor: Color.fromARGB(255, 177, 88, 84),
      barrierColor: color ?? Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        // https://stackoverflow.com/questions/52414629/how-to-update-state-of-a-modalbottomsheet-in-flutter
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
    ).then((value) {
      setState(() {
        // this is for the title, it makes sure that the title is the one it should show
        isModalActive -= 1;
        if (isModalActive == 0) {
          title = "Fitness App";
        }
      });
    });
    // await Future.delayed(const Duration(microseconds: 120000));
    setState(() {
      isModalActive += 1;
    });
  }

  void logInModalBottomSheet() {
    setState(() {
      title = "Welcome back";
    });
    if (isModalActive != 0) {
      Navigator.pop(context);
    }
    modalBottomSheet(
        Wrap(
          children: [
            MyTextField(
                hintText: "Name",
                prefixIcon:
                    Icon(Icons.account_circle_sharp, color: Colors.white)),
            MyPasswordTextField(hintText: "Password"),

            Row(
              children: [
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              ],
            ),
            // MyListTile(widget: MyElevatedButton(text: "Log in")),
            ListTile(
              title: MyElevatedButton(
                  text: "Sign in",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyNavBar()),
                    );
                  }),
              contentPadding: EdgeInsets.zero,
            ),
            Row(
              children: [
                Expanded(child: Divider(height: 10, color: Colors.white)),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    "or",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(child: Divider(height: 10, color: Colors.white)),
              ],
            ),
            ListTile(
                title: MyElevatedButton(
                  text: "Sign up",
                  onPressed: signUpModalBottomSheet,
                ),
                contentPadding: EdgeInsets.zero),
            ListTile(title: SizedBox(height: 40)),
          ],
        ),
        "Welcome back");
  }

  void signUpModalBottomSheet() {
    setState(() {
      title = "Create Account";
    });
    if (isModalActive != 0) {
      Navigator.pop(context);
    }
    modalBottomSheet(
        Wrap(
          children: [
            MyTextField(
                hintText: "Name",
                prefixIcon:
                    Icon(Icons.account_circle_sharp, color: Colors.white)),
            MyTextField(
                hintText: "Email",
                prefixIcon: Icon(Icons.email, color: Colors.white)),
            MyPasswordTextField(hintText: "Password"),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Center(
                  child: IconButton(
                      onPressed: pfpModalBottomSheet,
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.red,
                        size: 30,
                      ))),
            ),
            ListTile(
              title: MyElevatedButton(
                  text: "Sign up",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyNavBar()),
                    );
                  }),
              contentPadding: EdgeInsets.zero,
            ),
            Row(
              children: [
                Expanded(child: Divider(height: 10, color: Colors.white)),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text("or",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ),
                Expanded(child: Divider(height: 10, color: Colors.white)),
              ],
            ),
            ListTile(
                title: MyElevatedButton(
                  text: "Sign in",
                  onPressed: logInModalBottomSheet,
                ),
                contentPadding: EdgeInsets.zero),
            ListTile(title: SizedBox(height: 40)),
          ],
        ),
        "Create Account");
  }

  void pfpModalBottomSheet() {
    modalBottomSheet(
      Row(
        children: [
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.camera_alt,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.photo, size: 100, color: Colors.white),
            ),
          )
        ],
      ),
      "Profile Picture",
      Colors.black.withOpacity(0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.13),
              Align(
                alignment: Alignment.center,
                child: Text(title,
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: height * 0.55),
              SizedBox(
                height: height * 0.065,
                width: width * 0.39,
                child: MyElevatedButton(
                    text: "SIGN IN", onPressed: logInModalBottomSheet),
              ),
              SizedBox(height: height * 0.02),
              SizedBox(
                height: height * 0.065,
                width: width * 0.39,
                child: MyElevatedButton(
                    text: "SIGN UP", onPressed: signUpModalBottomSheet),
              )
            ],
          ),
        ),
      ),
    );
  }
}
