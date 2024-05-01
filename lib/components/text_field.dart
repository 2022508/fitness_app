import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Icon prefixIcon;
  final IconButton? suffixIcon;
  final bool? readOnly;
  final Color? color;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter> inputFormatters;
  const MyTextField(
      {super.key,
      required this.hintText,
      this.controller,
      required this.prefixIcon,
      this.suffixIcon,
      this.readOnly,
      this.color,
      this.onSubmitted,
      this.keyboardType,
      this.inputFormatters = const []});

  @override
  Widget build(BuildContext context) {
    final TextEditingController tempController = TextEditingController();
    return TextField(
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        controller: controller ?? tempController,
        style: TextStyle(color: color ?? Colors.black),
        readOnly: readOnly ?? false,
        onSubmitted: onSubmitted ??
            (s) {
              FocusManager.instance.primaryFocus?.unfocus();
              controller?.clear();
            },
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
