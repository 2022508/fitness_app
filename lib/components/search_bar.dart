import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;
  final void Function() onPressed;
  final void Function() onPressedVoice;
  final void Function(String)? onChanged;

  const MySearchBar(
      {super.key,
      required this.controller,
      required this.onSubmitted,
      required this.onPressed,
      required this.onPressedVoice,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.go,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: 'Search exercises',
        prefixIcon: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.search,
            size: 30,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: onPressedVoice,
          icon: const Icon(
            Icons.mic,
            size: 30,
          ),
        ),
        hintStyle: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
