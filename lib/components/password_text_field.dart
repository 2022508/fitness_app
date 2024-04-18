// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyPasswordTextField extends StatefulWidget {
  final String? hintText;
  const MyPasswordTextField({super.key, required this.hintText});

  @override
  State<MyPasswordTextField> createState() => _MyPasswordTextFieldState();
}

class _MyPasswordTextFieldState extends State<MyPasswordTextField> {
  bool isPswdVisible = true;
  Icon pswdVisible = Icon(Icons.visibility_off_outlined);

  @override
  Widget build(BuildContext context) {
    return TextField(
        obscureText: isPswdVisible,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            hintText: "${widget.hintText}",
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
                icon: pswdVisible)));
  }
}
