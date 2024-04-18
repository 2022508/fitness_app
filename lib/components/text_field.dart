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
        readOnly: readOnly ?? false,
        decoration:
            InputDecoration(prefixIcon: prefixIcon, hintText: hintText));
  }
}
