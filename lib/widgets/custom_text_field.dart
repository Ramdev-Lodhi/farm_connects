import 'package:flutter/material.dart';
import '../../constants/palette.dart'; // Assuming Palette class exists
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final FormFieldValidator<String>? validator; // Validator parameter
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.inputType = TextInputType.text,
    this.validator, // Initialize validator
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Palette.iconColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Palette.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Palette.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        contentPadding: const EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1),
      ),
      validator: validator, // Assign validator
    );
  }
}