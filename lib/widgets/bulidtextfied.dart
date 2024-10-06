import 'package:flutter/material.dart';

import '../constants/palette.dart';

class BuildTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  // Constructor
  const BuildTextField({
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.inputType,
    required this.controller,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor, // Assuming you have a Palette class
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
        validator: validator,
      ),
    );
  }
}
