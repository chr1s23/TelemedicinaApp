import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/service/connectivity_service.dart';
import 'package:chatbot/service/notification_service.dart';
import 'package:chatbot/utils/dashboard_listener.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/presentation.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'log_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final _log = Logger('Main');

Future<void> main() async {
  initializeLogger();
  WidgetsFlutterBinding.ensureInitialized(); // OBLIGATORIO antes de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('es'), // Español
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale("es", "EC"),
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AllowedColors.blue,
          fontFamily: "ArialNarrow"),
      home: SplashScreen(),
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
    Future.delayed(
        const Duration(milliseconds: 600), _checkAuth
        ); // pequeño delay visual
  }

  Future<void> _checkAuth() async {
    bool hasInternet = await ConnectivityService.hasInternetConnection();
    String? token = await secureStorage.read(key: "user_token");

    // Animar fade-out antes de navegar
    setState(() {
      _opacity = 0.0;
    });

    if (!hasInternet) {
      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;

      if (token != null) {
        _log.fine(
            "User has not internet connection. Redirecting to dasboard offline mode.");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => DashboardListener(
                    wasOffline: true,
                    child: Dashboard(
                      hasInternet: false,
                    ))),
            (_) => false);
      } else {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Presentation()), (_) => false);
      }
    } else {
      User? user = await User.loadUser();
      String? valid;

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
                
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    DashboardListener(wasOffline: false, child: Dashboard())),
            (_) => false);
      } else {
        _log.fine(
            "Some or all user information is missing. Redirecting to login.");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Presentation()), (_) => false);
      }
      
      
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
