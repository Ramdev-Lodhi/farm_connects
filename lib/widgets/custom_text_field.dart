import 'package:flutter/material.dart';
import '../../constants/palette.dart';
import '../cubits/home_cubit/home_cubit.dart'; // Assuming Palette class exists
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
    HomeCubit cubit = HomeCubit.get(context);
    return TextFormField(
      controller: controller,
      style: TextStyle(color: cubit.isDark ?Colors.white : Colors.black),
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: cubit.isDark ?Colors.white : Palette.iconColor,),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cubit.isDark ?Colors.white : Palette.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: cubit.isDark ?Colors.white : Palette.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        contentPadding: const EdgeInsets.all(10),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: cubit.isDark ?Colors.white : Palette.textColor1),
      ),
      validator: validator, // Assign validator
    );
  }
}