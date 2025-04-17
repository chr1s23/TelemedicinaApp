import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/providers/auth_provider.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/presentation.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'log_utils.dart';

final _log = Logger('Main');

void main() {
  initializeLogger();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale("es", "EC"),
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: AllowedColors.blue,
            fontFamily: "ArialNarrow"),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    //_checkAuth();
    Future.delayed(
        const Duration(milliseconds: 600), _checkAuth); // pequeño delay visual
  }

  Future<void> _checkAuth() async {
    String? token = await secureStorage.read(key: "user_token");
    User? user = await User.loadUser();
    String? valid;
    // Animar fade-out antes de navegar
    setState(() {
      _opacity = 0.0;
    });

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      valid = await AuthService.refreshToken(context, token);
    }

    // Esperar a que se complete la animación
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    if (valid != null && user != null) {
      User.setCurrentUser(user, save: false);

      secureStorage.write(key: "user_token", value: valid);

      _log.fine("User info found in secure storage. Skipping login.");

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Dashboard()), (_) => false);
    } else {
      _log.fine("Some or all user information is missing. Redirecting to login.");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Presentation()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllowedColors.white,
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 1000),
        opacity: _opacity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo_ucuenca_top.png',
                        height: 100),
                    const SizedBox(height: 20),
                    Image.asset('assets/images/logo_clias.png', height: 80),
                    const SizedBox(height: 30),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "VERSIÓN BETA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AllowedColors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
