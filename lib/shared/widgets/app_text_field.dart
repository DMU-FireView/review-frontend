import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.labelText,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    super.key,
  });

  final String labelText;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: labelText, hintText: hintText),
    );
  }
}
