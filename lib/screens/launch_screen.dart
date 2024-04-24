// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_declarations, use_build_context_synchronously

// https://www.youtube.com/watch?v=_3W-JuIVFlg
// used for the log in and log out system

// https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
// used so the modal bottom sheet wouldnt be covered by the keyboard

// https://stackoverflow.com/questions/52414629/how-to-update-state-of-a-modalbottomsheet-in-flutter
// used to update the state of the modal bottom sheet for the title

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:fitness_app/services/camera_services.dart';
import 'package:fitness_app/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final signinEmailController = TextEditingController();
  final signinPasswordController = TextEditingController();

  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();

  final CameraServices cameraServices = CameraServices();

  Future<void> _saveUserDetails() async {
    final path = (await getApplicationDocumentsDirectory()).path;

    await DatabaseServices.addUserDetails(signupEmailController.text, path);
  }

  Future<void> signIn() async {
    if (signinEmailController.text.isNotEmpty &&
        signinPasswordController.text.isNotEmpty) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: signinEmailController.text.trim(),
            password: signinPasswordController.text.trim());
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'user-not-found') {
          alertDialog(Text("No user found for that email."));
        } else if (e.code == 'wrong-password') {
          alertDialog(Text("Wrong password provided for that user."));
        } else if (e.code == 'invalid-email') {
          alertDialog(Text("Invalid email provided."));
        }
      }
    } else {
      alertDialog(Text("Please fill in all fields."));
      //stops the leyboard popping back up after the dialog is closed
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future signUp() async {
    if (signupNameController.text.isNotEmpty &&
        signupEmailController.text.isNotEmpty &&
        signupPasswordController.text.isNotEmpty &&
        image != null) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: signupEmailController.text,
                password: signupPasswordController.text);
        Navigator.pop(context);
        await _saveUserDetails();

        await cameraServices.saveImage(image!, signupEmailController.text);
        await result.user?.updateDisplayName(signupNameController.text);

        //profile picture upload stuff
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'weak-password') {
          alertDialog(Text("The password provided is too weak."));
        } else if (e.code == 'email-already-in-use') {
          alertDialog(Text("The account already exists for that email."));
        } else if (e.code == 'invalid-email') {
          alertDialog(Text("Invalid email provided."));
        } else {
          alertDialog(Text("An error occured."));
        }
      }
    } else {
      alertDialog(Text("Please fill in all fields."));
      //stops the leyboard popping back up after the dialog is closed
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void alertDialog(Text error) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: error);
        });
  }

  String title = "FITNESS APP";
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);
  bool isPswdVisible = true;
  int isModalActive = 0;

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
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: widget);
        });
      },
    ).then((value) async {
      FocusManager.instance.primaryFocus?.unfocus();

      await Future.delayed(const Duration(microseconds: 130000));

      setState(() {
        // this is for the title, it makes sure that the title is the one it should show
        isModalActive -= 1;
        if (isModalActive == 0) {
          title = "Fitness App";
        }
      });
    });
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
              hintText: "Email",
              controller: signinEmailController,
              prefixIcon: Icon(Icons.account_circle_sharp, color: Colors.white),
              color: Colors.white,
            ),
            MyPasswordTextField(
                hintText: "Password",
                controller: signinPasswordController,
                color: Colors.white),
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
            ListTile(
              title: MyElevatedButton(
                  text: "Sign in",
                  onPressed: () {
                    signIn();
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
                controller: signupNameController,
                hintText: "Name",
                prefixIcon:
                    Icon(Icons.account_circle_sharp, color: Colors.white),
                color: Colors.white),
            MyTextField(
                controller: signupEmailController,
                hintText: "Email",
                prefixIcon: Icon(Icons.email, color: Colors.white),
                color: Colors.white),
            MyPasswordTextField(
                controller: signupPasswordController,
                hintText: "Password",
                color: Colors.white),
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
                    signUp();
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
          ],
        ),
        "Create Account");
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> getPhoto(ImageSource type) async {
    final XFile? pickedImage = await picker.pickImage(source: type);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: height * 0.07),
              Align(
                alignment: Alignment.center,
                child: Text(title,
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              Builder(builder: (context) {
                if (isModalActive == 0) {
                  return Column(
                    children: [
                      SizedBox(height: height * 0.57),
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
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
