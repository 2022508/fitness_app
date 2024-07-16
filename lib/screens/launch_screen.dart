// https://www.youtube.com/watch?v=_3W-JuIVFlg
// used for the log in and log out system

// https://stackoverflow.com/questions/53869078/how-to-move-bottomsheet-along-with-keyboard-which-has-textfieldautofocused-is-t
// used so the modal bottom sheet wouldnt be covered by the keyboard

// https://stackoverflow.com/questions/52414629/how-to-update-state-of-a-modalbottomsheet-in-flutter
// used to update the state of the modal bottom sheet for the title

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/components/elevated_button.dart';
import 'package:fitness_app/components/password_text_field.dart';
import 'package:fitness_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  final signinEmailController = TextEditingController();
  final signinPasswordController = TextEditingController();

  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();

  final resetPasswordEmailController = TextEditingController();
  bool canResendEmail = false;
  Timer? timer;

  String title = "FitPulse";
  Icon pswdVisible = const Icon(Icons.visibility_off_outlined);
  bool isPswdVisible = true;
  int isModalActive = 0;

  Future<void> signIn() async {
    if (signinEmailController.text.isNotEmpty &&
        signinPasswordController.text.isNotEmpty) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: signinEmailController.text.trim(),
            password: signinPasswordController.text.trim());
        //gets id of circular progress indicator
        if (mounted) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.pop(context);
        }
        if (e.code == 'invalid-email' ||
            e.code == 'user-not-found' ||
            e.code == 'wrong-password') {
          alertDialog(const Text("Invalid details provided."));
        } else {
          alertDialog(const Text("An error occured."));
        }
      }
    } else {
      alertDialog(const Text("Please fill in all fields."));
      //stops the leyboard popping back up after the dialog is closed
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future signUp() async {
    if (signupEmailController.text.isNotEmpty &&
        signupPasswordController.text.isNotEmpty) {
      Navigator.pop(context);

      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: signupEmailController.text,
            password: signupPasswordController.text);
        //gets id of circular progress indicator
        if (mounted) {
          Navigator.pop(context);
        }

        //profile picture upload stuff
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          Navigator.pop(context);
        }
        if (e.code == 'weak-password') {
          alertDialog(const Text("The password provided is too weak."));
        } else if (e.code == 'invalid-email' ||
            e.code == 'email-already-in-use') {
          alertDialog(const Text("Invalid email provided."));
        } else {
          alertDialog(const Text("An error occured."));
        }
      }
    } else {
      alertDialog(const Text("Please fill in all fields."));
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
          title = "FitPulse";
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
              keyboardType: TextInputType.emailAddress,
              hintText: "Email",
              controller: signinEmailController,
              prefixIcon:
                  const Icon(Icons.account_circle_sharp, color: Colors.white),
              color: Colors.white,
            ),
            MyPasswordTextField(
                hintText: "Password",
                controller: signinPasswordController,
                color: Colors.white),
            Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: sendVerificationEmail,
                    child: const Text(
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
            const Row(
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
                keyboardType: TextInputType.emailAddress,
                controller: signupEmailController,
                hintText: "Email",
                prefixIcon: const Icon(Icons.email, color: Colors.white),
                color: Colors.white),
            MyPasswordTextField(
                controller: signupPasswordController,
                hintText: "Password",
                color: Colors.white),
            const SizedBox(height: 98),
            ListTile(
              title: MyElevatedButton(
                  text: "Sign up",
                  onPressed: () {
                    signUp();
                  }),
              contentPadding: EdgeInsets.zero,
            ),
            const Row(
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

  Future sendVerificationEmail() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(5),
            title: const Text("Reset Password"),
            content: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: resetPasswordEmailController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10), hintText: "Email")),
            actions: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  const Spacer(),
                  TextButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: resetPasswordEmailController.text);
                          setState(() {
                            canResendEmail = false;
                          });
                          await Future.delayed(const Duration(seconds: 5));
                          setState(() {
                            canResendEmail = true;
                          });
                        } catch (e) {
                          log(e.toString());
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                        alertDialog(const Text("Email sent"));
                      },
                      child: const Text("Send")),
                ],
              )
            ],
          );
        });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetPasswordEmailController.text);
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
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
                    style: const TextStyle(
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
                  return const SizedBox();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
