import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;
  final void Function()? onPressed;

  const MyElevatedButton(
      {super.key,
      required this.text,
      this.backgroundColor,
      this.textColor,
      this.size,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.deepOrange[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(color: Colors.yellow, width: 2.5),
        ),
        child: Text(text,
            style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: size ?? 25,
                fontWeight: FontWeight.bold)));
  }
}
