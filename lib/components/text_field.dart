// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final bool? readOnly;
  final Color? color;
  const MyTextField(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      this.readOnly,
      this.color});

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: color ?? Colors.black),
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(color: color ?? Colors.black),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color ?? Colors.black),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color ?? Colors.black),
          ),
        ));
  }
}
