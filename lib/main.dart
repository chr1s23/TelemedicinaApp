import 'package:chatbot/presentation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: "ArialNarrow"),
    home: Presentation(),
  ));
}
