import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/providers/auth_provider.dart';
import 'package:chatbot/providers/chat_provider.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/presentation.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'log_utils.dart';

void main() {
  initializeLogger();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    String? token = await secureStorage.read(key: "user_token");

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Dashboard()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Presentation()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Muestra un loader mientras verifica el token
      ),
    );
  }
}
