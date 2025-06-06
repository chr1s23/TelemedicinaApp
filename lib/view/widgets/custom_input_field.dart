import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final String errorMessage;
  final bool isNumber;

  const CustomInputField({super.key, required this.controller, required this.hint, required this.obscureText, required this.errorMessage, required this.isNumber});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [isNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      controller: controller,
      obscureText: obscureText,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return errorMessage;
        }
        return null;
      },
      style: TextStyle(fontSize: 15, color: AllowedColors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: AllowedColors.gray, fontSize: 13),
        errorStyle:
            TextStyle(fontSize: 12, color: AllowedColors.red),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: AllowedColors.gray, width: 1.0),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AllowedColors.gray, width: 1.5),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AllowedColors.gray, width: 1.0),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}