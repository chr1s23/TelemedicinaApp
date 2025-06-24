import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../main.dart'; // Para acceder al navigatorKey

class FirebaseMessagingHandler {
  static Future<void> initializeFCM() async {
    //  Si la app se abrió desde una notificación (CERRADA COMPLETAMENTE)
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    //  Cuando está en SEGUNDO PLANO y el usuario toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    //  Cuando está en PRIMER PLANO (opcional, puedes mostrar alerta)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // usar un snackbar, dialog, etc. si quieres avisar al usuario
      print("📬 Mensaje recibido en primer plano: ${message.data}");
    });
  }

  static void _handleMessage(RemoteMessage message) {
    final data = message.data;
    final tipo = data['tipo'];
    final id = data['id'];

    if (tipo == 'RESULTADO') {
      navigatorKey.currentState?.pushNamed('/ver_pdf', arguments: id);
    } else if (tipo == 'RECORDATORIO') {
      navigatorKey.currentState?.pushNamed('/notificaciones');
    }
  }
}
