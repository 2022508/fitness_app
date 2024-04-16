// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyWorkoutsButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final void Function()? onPressed;

  const MyWorkoutsButton(
      {super.key,
      required this.text,
      this.backgroundColor,
      this.textColor,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w400)),
          Spacer(),
          Icon(Icons.info_outline, color: Colors.black, size: 30, weight: 20),
        ],
      ),
    );
  }
}
