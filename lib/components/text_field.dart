// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final bool? readOnly;
  const MyTextField(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: Colors.white),
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ));
  }
}
