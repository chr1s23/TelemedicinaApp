import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart'; // Para acceder al navigatorKey

class FirebaseMessagingHandler {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future<void> initializeFCM() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    //  Si la app se abrió desde una notificación (CERRADA COMPLETAMENTE)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    //  Cuando está en SEGUNDO PLANO y el usuario toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    //  Cuando está en PRIMER PLANO (opcional, puedes mostrar alerta)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📬 Mensaje recibido en primer plano: ${message.data}");
      Dashboard.globalKey.currentState?.actualizarNotificacionesDesdeExterior();
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'canal_principal',
              'Notificaciones CLIAS',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: false,
            ),
          ),
        );
        Notifications.globalKey.currentState?.recargarDesdeExterior();
        

      }
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
