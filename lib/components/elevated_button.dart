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
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(backgroundColor ?? Colors.grey),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        child: Text(text,
            style: TextStyle(
                color: textColor ?? Colors.black, fontSize: size ?? 20)));
  }
}
