import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/screens/launch_screen.dart';
import 'package:fitness_app/screens/navbar_screen.dart';
import 'package:flutter/material.dart';

class MyAuth extends StatelessWidget {
  const MyAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyNavBar();
          } else {
            return const LaunchScreen();
          }
        },
      ),
    );
  }
}