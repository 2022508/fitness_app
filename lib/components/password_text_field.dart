// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyPasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final Color? color;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  const MyPasswordTextField(
      {super.key,
      required this.hintText,
      this.controller,
      this.color,
      this.prefixIcon,
      this.suffixIcon});

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
    final TextEditingController tempController =
        TextEditingController(text: "");
    return TextField(
        controller: widget.controller ?? tempController,
        style: TextStyle(color: widget.color ?? Colors.black),
        obscureText: isPswdVisible,
        decoration: InputDecoration(
            prefixIcon:
                widget.prefixIcon ?? Icon(Icons.lock, color: Colors.white),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: widget.color ?? Colors.black),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: widget.color ?? Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: widget.color ?? Colors.black),
            ),
            suffixIcon: widget.suffixIcon ??
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (isPswdVisible) {
                          pswdVisible = Icon(Icons.visibility_outlined,
                              color: Colors.white);
                          isPswdVisible = false;
                        } else {
                          pswdVisible = Icon(Icons.visibility_off_outlined,
                              color: Colors.white);
                          isPswdVisible = true;
                        }
                      });
                    },
                    icon: pswdVisible)));
  }
}
