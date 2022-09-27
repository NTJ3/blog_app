import 'package:flutter/material.dart';

//typedef StringCallback = ValueChanged<String>;

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onValidator;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  final bool? obscureText;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.controller,
    this.onSubmitted,
    this.onValidator,
    this.inputAction,
    this.focusNode,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
        ),
        controller: controller,
        validator: onValidator as String? Function(String?)?,
        onFieldSubmitted: onSubmitted,
        textInputAction: inputAction,
        focusNode: focusNode,
        //maxLength: 70,
        obscureText: obscureText != null ? obscureText! : false,
      );
}
