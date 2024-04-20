// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyPasswordTextField extends StatefulWidget {
  final String? hintText;
  final Color? color;
  const MyPasswordTextField({super.key, required this.hintText, this.color});

  @override
  State<MyPasswordTextField> createState() => _MyPasswordTextFieldState();
}

class _MyPasswordTextFieldState extends State<MyPasswordTextField> {
  bool isPswdVisible = true;
  Icon pswdVisible = Icon(
    Icons.visibility_off_outlined,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: widget.color ?? Colors.black),
        obscureText: isPswdVisible,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock, color: Colors.white),
            hintText: "${widget.hintText}",
            hintStyle: TextStyle(color: widget.color ?? Colors.black),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: widget.color ?? Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: widget.color ?? Colors.black),
            ),
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
