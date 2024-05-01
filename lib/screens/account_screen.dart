// https://www.youtube.com/watch?v=t_GcR_9-NcY
// used to help delete the users data from firestore

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/services/auth_services.dart';
import 'package:fitness_app/services/camera_services.dart';
import 'package:fitness_app/services/database_services.dart';
import 'package:fitness_app/services/workout_data_services.dart';
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
  Icon pswdVisible = const Icon(Icons.visibility_off_outlined);
  bool isImageLoaded = false;
  bool isUserLoaded = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final CameraServices cameraServices = CameraServices();
  final AuthServices authServices = AuthServices();
  final WorkoutDataService workoutDataService = WorkoutDataService();

  XFile? image;
  final ImagePicker picker = ImagePicker();
  String? path;
  String? fileName;

  final fire = FirebaseAuth.instance;

  Future<void> loadImage() async {
    Map<String, dynamic> getData =
        await DatabaseServices.getUsersDetailsByEmail(fire.currentUser!.email!);
    try {
      path = getData['path'];
      fileName = getData['email'];
      if (File('$path/$fileName').existsSync()) {
        setState(() {
          isImageLoaded = true;
          image = XFile('$path/$fileName');
          path = getData['path'];
          fileName = getData['email'];
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
              icon: const Icon(
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
              icon: const Icon(Icons.photo, size: 100, color: Colors.white),
            ),
          )
        ],
      ),
      "Profile Picture",
      Colors.black.withOpacity(0.5),
    );
  }

  void getUser() {
    authServices.getUser();
    if (fire.currentUser != null) {
      setState(() {
        isUserLoaded = true;
        nameController.text = fire.currentUser!.displayName!;
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
      // delete image from device
      cameraServices.deleteImage(fileName!, path!);
      // delete user from local database
      DatabaseServices.deleteUserDetails(email);
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
    loadImage();
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
              Stack(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: image == null
                        ? const AssetImage('assets/images/pfp.jpg')
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
              const SizedBox(height: 20),
              if (isUserLoaded)
                Column(
                  children: [
                    MyTextField(
                        controller: nameController,
                        hintText: "Name",
                        prefixIcon: const Icon(Icons.account_circle_sharp),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.upload,
                              color: Colors.red, size: 30),
                          onPressed: () {
                            fire.currentUser!
                                .updateDisplayName(nameController.text);
                            alertDialog(const Text("Name updated."));
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        )),
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
