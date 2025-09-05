import 'dart:async';
import 'dart:convert';
import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/service/connectivity_service.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/service/sesion_chat_service.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/auth_service.dart';
import 'package:chatbot/view/screens/login.dart';
import 'package:logging/logging.dart';

final _log = Logger('DasboardListener');

class DashboardListener extends StatefulWidget {
  final Widget child;
  final bool wasOffline;

  const DashboardListener(
      {super.key, required this.child, required this.wasOffline});

  @override
  State<DashboardListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<DashboardListener> {
  Timer? _timer;
  bool _wasOffline = false;

  @override
  void initState() {
    super.initState();
    _wasOffline = widget.wasOffline;
    _startMonitoring();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      final isOnline = await ConnectivityService.hasInternetConnection();

      if (isOnline) {
        String? pending = await secureStorage.read(key: "pending_device");
        String? formRequest = await secureStorage.read(key: "form_request");
        if (!mounted) return;
        if (_wasOffline) {
          _checkAuth(context, null, null);
        }
        if (pending != null || formRequest != null) {
          _log.fine("Cheking auth, requests are pending");
          _checkAuth(context, pending, formRequest);
        }
      }
    });
  }

  void _checkAuth(
      BuildContext context, String? pending, String? formRequest) async {
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
      if (pending != null) {
        String? device = await secureStorage.read(key: "user_device");
        if (!context.mounted) return;
        PacienteService.registrarDispositivo(
            context, DispositivoRequest(device!));
      }

      if (formRequest != null && context.mounted) {
        SesionChatRequest sesion =
            SesionChatRequest.fromJson(jsonDecode(formRequest));
        SesionChatService.registrarInfoExamen(context, sesion);
      }
      if (_wasOffline) {
        _wasOffline = false;
      }
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
