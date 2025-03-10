import 'package:chatbot/providers/auth_provider.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/view/screens/presentation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ChatProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider())
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale("es", "EC"),
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Color.fromRGBO(0, 40, 86, 1),
          fontFamily: "ArialNarrow"),
      home: Presentation(),
    ),
  ));
}
