import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class CustomInputDecoration {
  static InputDecoration getDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText, // Placeholder
      hintStyle: TextStyle(
          color: AllowedColors.gray,
          fontSize: 12), // Estilo del placeholder
      errorStyle: TextStyle(fontSize: 12, color: AllowedColors.red),
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: AllowedColors.gray, width: 1.0),
        borderRadius: BorderRadius.circular(30), // Borde redondeado opcional
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
    );
  }
}
