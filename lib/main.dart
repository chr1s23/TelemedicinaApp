import 'package:chatbot/providers/auth_provider.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/view/screens/presentation.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'log_utils.dart';

void main() {
  initializeLogger();

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
          colorSchemeSeed: AllowedColors.blue,
          fontFamily: "ArialNarrow"),
      home: Presentation(),
    ),
  ));
}
