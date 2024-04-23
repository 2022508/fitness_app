// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Icon prefixIcon;
  final IconButton? suffixIcon;
  final bool? readOnly;
  final Color? color;
  const MyTextField(
      {super.key,
      required this.hintText,
      this.controller,
      required this.prefixIcon,
      this.suffixIcon,
      this.readOnly,
      this.color});

  @override
  Widget build(BuildContext context) {
    final TextEditingController tempController =
        TextEditingController(text: "sdg");
    return TextField(
        controller: controller ?? tempController,
        style: TextStyle(color: color ?? Colors.black),
        readOnly: readOnly ?? false,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
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
