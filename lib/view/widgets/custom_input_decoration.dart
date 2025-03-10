import 'package:flutter/material.dart';

class CustomInputDecoration {
  InputDecoration getDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText, // Placeholder
      hintStyle: TextStyle(
          color: Color.fromRGBO(111, 111, 111, 1),
          fontSize: 12), // Estilo del placeholder
      errorStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(165, 16, 8, 1)),
      border: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
        borderRadius: BorderRadius.circular(30), // Borde redondeado opcional
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
