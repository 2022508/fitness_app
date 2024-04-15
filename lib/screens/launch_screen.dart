// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:fitness_app/components/elevated_button.dart';
import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  String title = ("Fitness App");
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);
  bool isPswdVisible = true;

  Future<void> loginModalBottomSheet() async {
    setState(() {
      title = "Welcome back!";
    });

    showModalBottomSheet(
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        // https://stackoverflow.com/questions/52414629/how-to-update-state-of-a-modalbottomsheet-in-flutter
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
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
                                  pswdVisible =
                                      Icon(Icons.visibility_off_outlined);
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
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text("or", textAlign: TextAlign.center),
                    ),
                    Expanded(child: Divider(height: 10)),
                  ],
                ),
                ListTile(
                    title: MyElevatedButton(text: "Sign up"),
                    contentPadding: EdgeInsets.zero),
                ListTile(title: SizedBox(height: 40)),
              ],
            ),
          );
        });
      },
    ).then((value) {
      setState(() {
        title = "Fitness App";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    text: "Log in",
                    onPressed: loginModalBottomSheet,
                  )),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Expanded(child: MyElevatedButton(text: "Sign up")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
