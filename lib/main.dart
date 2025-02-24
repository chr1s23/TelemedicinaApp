import 'package:chatbot/view/screens/presentation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: Locale("es", "EC"),
    theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color.fromRGBO(0, 40, 86, 1),
        fontFamily: "ArialNarrow"),
    home: Presentation(),
  ));
}
