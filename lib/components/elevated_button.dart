// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double? size;
  final void Function()? onPressed;

  const MyElevatedButton(
      {super.key,
      required this.text,
      this.backgroundColor,
      this.borderColor,
      this.textColor,
      this.size,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Color.fromRGBO(201, 56, 11, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(
              color: borderColor ?? Color.fromARGB(255, 247, 184, 24),
              width: 2.5),
        ),
        child: Text(text,
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: size ?? 25,
                fontWeight: FontWeight.bold)));
  }
}
