// https://www.youtube.com/watch?v=t_GcR_9-NcY
// used to help delete the users data from firestore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/services/auth_services.dart';
import 'package:fitness_app/services/workout_data_services.dart';
import 'package:flutter/material.dart';
// import 'dart:developer';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isPswdVisible = true;
  Icon pswdVisible = const Icon(Icons.visibility_off_outlined);
  bool isUserLoaded = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthServices authServices = AuthServices();
  final WorkoutDataService workoutDataService = WorkoutDataService();

  final fire = FirebaseAuth.instance;

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

  void getUser() {
    authServices.getUser();
    if (fire.currentUser != null) {
      setState(() {
        isUserLoaded = true;
        emailController.text = fire.currentUser!.email!;
      });
    }
  }

  Future updatePassword() async {
    if (passwordController.text.isNotEmpty) {
      try {
        await fire.currentUser?.updatePassword(passwordController.text);
        passwordController.clear();
        alertDialog(const Text("Password updated."));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          alertDialog(const Text("The password provided is too weak."));
        } else if (e.code == 'requires-recent-login') {
          alertDialog(const Text("Please log in to the app again."));
        } else {
          alertDialog(const Text("An error occured."));
        }
      }
    } else {
      alertDialog(const Text("Password cannot be empty."));
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void alertDialog(Text error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: error);
        });
  }

  Future<void> deleteUser() async {
    String? email = fire.currentUser!.email;
    // delete user and data from firebase
    try {
      await fire.currentUser?.delete();
      // delete data from firestore
      workoutDataService.deleteWorkoutDataLog(email!);
      workoutDataService.deleteWorkoutDataCreate(email);
      workoutDataService.deleteUserData(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        alertDialog(const Text("Please log in to the app again."));
      } else {
        alertDialog(const Text("An error occured."));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
            children: [
              const SizedBox(height: 20),
              if (isUserLoaded)
                Column(
                  children: [
                    CircleAvatar(
                        radius: 200,
                        child: Image.asset("assets/images/icon.png")),
                    MyTextField(
                      controller: emailController,
                      hintText: "email@gmail.com",
                      prefixIcon: const Icon(Icons.email),
                      readOnly: true,
                    ),
                    MyPasswordTextField(
                      controller: passwordController,
                      hintText: "New password",
                      color: Colors.black,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.upload,
                            color: Colors.red, size: 30),
                        onPressed: updatePassword,
                      ),
                    ),
                    Row(
                      children: [
                        const Expanded(child: Divider(height: 10)),
                        Padding(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          child: TextButton(
                              child: const Text("Delete account",
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () async {
                                await deleteUser();
                              }),
                        ),
                        const Expanded(child: Divider(height: 10)),
                      ],
                    ),
                    MyElevatedButton(
                        text: "Sign out",
                        onPressed: () async {
                          await fire.signOut();
                        })
                  ],
                )
              else
                const Center(child: CircularProgressIndicator()),
            ],
          )),
        ),
      ),
    ));
  }
}
