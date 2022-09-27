import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputAction inputAction;
  final bool inputFilled;
  final bool secureText;

  const CustomInput(
      {super.key,
      required this.label,
      required this.controller,
      required this.inputAction,
      required this.inputFilled,
      required this.secureText});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey[300],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          textInputAction: inputAction,
          decoration: InputDecoration.collapsed(
              filled: inputFilled,
              hintText: label,
              hintStyle: TextStyle(
                color: Colors.grey[800],
              )),
          obscureText: secureText,
        ),
      );
}
