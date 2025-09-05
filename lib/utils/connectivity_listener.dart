import 'dart:async';
import 'package:chatbot/service/connectivity_service.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/screens/login.dart';
import 'package:chatbot/view/screens/offline_chat.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  Timer? _timer;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final isOnline = await ConnectivityService.hasInternetConnection();
      if (!isOnline && !_wasOffline) {
        _wasOffline = true;
        if (mounted) {
          showSnackBar(context, "Sin conexión a internet");
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const OfflineChat()),
          );
        }
      } else if (isOnline && _wasOffline) {
        _wasOffline = false;
        if (!mounted) return;
        showSnackBar(context, "Recuperaste la conexión a internet");
        _checkAuth(context);
      }
    });
  }

  void _checkAuth(BuildContext context) async {
    String? token = await secureStorage.read(key: "user_token");
    User? user = await User.loadUser();
    String? valid;

    if (!context.mounted) return;

    if (token != null && token.isNotEmpty) {
      valid = await AuthService.refreshToken(context, token);
    }

    if (!context.mounted) return;

    if (valid != null && user != null) {
      User.setCurrentUser(user, save: false);
      secureStorage.write(key: "user_token", value: valid);
      if (Navigator.canPop(context)) Navigator.pop(context);
    } else {
      _showSessionExpiredDialog(context);
    }
  }

  void _showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inicia sesión'),
          content: const Text(
              'Recuperaste la conexión a internet y hemos detectado que tu sesión ha caducado.\nPor favor vuelve a iniciar sesión!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
                  (_) => false,
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
