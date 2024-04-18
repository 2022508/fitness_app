// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/components/elevated_button.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  String title = "Fitness App";
  String pastTitle = "";
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);
  bool isPswdVisible = true;
  int isModalActive = 0;

  void modalBottomSheet(Widget widget, String newTitle, [Color? color]) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      barrierColor: color ?? Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        // https://stackoverflow.com/questions/52414629/how-to-update-state-of-a-modalbottomsheet-in-flutter
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(padding: const EdgeInsets.all(8.0), child: widget);
        });
      },
    ).then((value) {
      setState(() {
        // this is for the title, it makes sure that the title is the one it should show
        isModalActive -= 1;
        if (isModalActive == 0) {
          title = "Fitness App";
        } else {
          title = pastTitle;
        }
      });
    });
    // await Future.delayed(const Duration(microseconds: 120000));
    setState(() {
      pastTitle = title;
      title = newTitle;
      isModalActive += 1;
    });
  }

  void logInModalBottomSheet() {
    modalBottomSheet(
        Wrap(
          children: [
            TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email), hintText: "Email")),
            TextField(
                obscureText: isPswdVisible,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (isPswdVisible) {
                              pswdVisible = Icon(Icons.visibility_outlined);
                              isPswdVisible = false;
                            } else {
                              pswdVisible = Icon(Icons.visibility_off_outlined);
                              isPswdVisible = true;
                            }
                          });
                        },
                        icon: pswdVisible))),
            Row(
              children: [
                Spacer(),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                    )),
              ],
            ),
            // MyListTile(widget: MyElevatedButton(text: "Log in")),
            ListTile(
              title: MyElevatedButton(text: "Log in"),
              contentPadding: EdgeInsets.zero,
            ),
            Row(
              children: [
                Expanded(child: Divider(height: 10)),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text("or", textAlign: TextAlign.center),
                ),
                Expanded(child: Divider(height: 10)),
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
    modalBottomSheet(
        Wrap(
          children: [
            TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_sharp),
                    hintText: "Name")),
            TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email), hintText: "Email")),
            TextField(
                obscureText: isPswdVisible,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (isPswdVisible) {
                              pswdVisible = Icon(Icons.visibility_outlined);
                              isPswdVisible = false;
                            } else {
                              pswdVisible = Icon(Icons.visibility_off_outlined);
                              isPswdVisible = true;
                            }
                          });
                        },
                        icon: pswdVisible))),
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
              title: MyElevatedButton(text: "Sign up"),
              contentPadding: EdgeInsets.zero,
            ),
            Row(
              children: [
                Expanded(child: Divider(height: 10)),
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Text("or", textAlign: TextAlign.center),
                ),
                Expanded(child: Divider(height: 10)),
              ],
            ),
            ListTile(
                title: MyElevatedButton(
                  text: "Log in",
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
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.photo, size: 100),
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              children: [
                const SizedBox(height: 200),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title, style: TextStyle(fontSize: 30)),
                ),
                const SizedBox(height: 300),
                Row(
                  children: [
                    Expanded(
                        child: MyElevatedButton(
                            text: "Log in", onPressed: logInModalBottomSheet)),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                        child: MyElevatedButton(
                            text: "Sign up",
                            onPressed: signUpModalBottomSheet)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
