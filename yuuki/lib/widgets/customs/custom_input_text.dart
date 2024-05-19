import 'package:flutter/material.dart';

class CustomInputText extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool autoFocus;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool obscureText; // Add this line

  const CustomInputText({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.autoFocus = false,
    this.onChanged,
    this.onSaved,
    required this.validator,
    this.suffixIcon, // Add this line
    this.obscureText = false, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autofocus: autoFocus,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      obscureText: obscureText, // Add this line
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.blue),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        suffixIcon: suffixIcon, // Add this line
      ),
      style: TextStyle(color: Colors.blue),
    );
  }
}
