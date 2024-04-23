import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/launch_screen.dart';
import 'package:fitness_app/screens/verify_email_screen.dart';
import 'package:flutter/material.dart';

class MyAuth extends StatelessWidget {
  const MyAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            if (snapshot.data?.displayName != null) {
              return const VerifyEmailScreen();
            } else {
              return const LaunchScreen();
            }
          } else {
            return const LaunchScreen();
          }
        },
      ),
    );
  }
}
