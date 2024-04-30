// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  Future<void> getUser() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
    }
  }
}
