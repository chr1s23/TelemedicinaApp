import 'package:chatbot/service/notification_service.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/notifications.dart';
import 'package:chatbot/view/screens/resultado_viewer.dart';
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

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'canal_principal', // ID del canal
      'Notificaciones CLIAS', // Nombre visible
      description: 'Canal para notificaciones importantes',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    //  Si la app se abrió desde una notificación (CERRADA COMPLETAMENTE)
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    //  Cuando está en SEGUNDO PLANO y el usuario toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      manejarClickNotificacion(message.data);
    });

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
    final tipo = data['tipoNotificacion'];

    if (tipo == 'RESULTADO') {
      print("📄 Resultado recibido");
    } else if (tipo == 'RECORDATORIO') {
      print("📅 Recordatorio recibido");
    }
  }

  static Future<void> manejarClickNotificacion(
      Map<String, dynamic> data) async {
    final publicId = data["publicId"];
    final tipo = data["tipoNotificacion"];
    print("---- 📬 Click en notificación: $publicId, tipo: $tipo");

    if (publicId != null) {
      try {
        await NotificationService.marcarNotificacionComoLeida(publicId);
        Dashboard.globalKey.currentState
            ?.actualizarNotificaciones(); // Actualiza punto rojo
      } catch (e) {
        print("[X] Error al marcar como leída desde mensaje abierto: $e");
      }
    }

    if (tipo == "RESULTADO") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const ResultadoViewer()),
      );
    }
  }
}
