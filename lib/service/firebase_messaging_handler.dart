import 'package:chatbot/service/notification_service.dart';
import 'package:chatbot/utils/resultado_utils.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/notifications.dart';
import 'package:chatbot/view/screens/requiredSocioeconomicForm.dart';
import 'package:chatbot/view/screens/resources.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:chatbot/view/screens/encuesta_sus.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/utils/notificacion_flags.dart';
import 'package:chatbot/service/encuesta_service.dart';
import 'package:chatbot/service/paciente_service.dart';
import 'package:chatbot/view/screens/socioeconomic_information.dart';

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
      actualizarNotificacionesEnMemoria();
      manejarClickNotificacion(message.data);
    });

    //  Cuando está en PRIMER PLANO (opcional, puedes mostrar alerta)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Dashboard.globalKey.currentState?.actualizarNotificacionesDesdeExterior();
      actualizarNotificacionesEnMemoria();
      NotificacionFlags.hayNotificacionNueva = true;

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
    final contxt = navigatorKey.currentContext!;

    if (publicId != null) {
      try {
        await NotificationService.marcarNotificacionComoLeida(publicId);
        Dashboard.globalKey.currentState
            ?.actualizarNotificaciones(); // Actualiza punto rojo
      } catch (e) {
        print("[X] Error al marcar como leída desde mensaje abierto: $e");
      }
    }
    print("[MENSAJE]TIPO DE NOTIFICACIÓN: $tipo");
    //Mostramos un circular progress indicator mientras se carga el resultado

    showDialog(
      context: contxt,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    if (tipo == "RESULTADO") {
      final cuentaUsuarioId = await secureStorage.read(key: "user_id");

      if (cuentaUsuarioId != null) {
        try {
          final existeFicha =
              await PacienteService.verificarFichaSocioeconomica(
                  cuentaUsuarioId);

          print(
              "[MENSAJE] Existe ficha socioeconómica: $existeFicha de usuario $cuentaUsuarioId");

          if (!existeFicha) {
            final paciente =
                await PacienteService.getPaciente(navigatorKey.currentContext!);
            if (paciente != null) {
              Navigator.of(contxt).pop();
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (_) => RequiredSocioeconomicForm(paciente: paciente),
                ),
              );
            } else {
              print("[X] No se pudo obtener la información del paciente.");
            }
            return;
          }

          final completada = await EncuestaService.verificarEncuestaCompletada(
              cuentaUsuarioId);

          if (completada) {
            final ctx = navigatorKey.currentContext;
            if (ctx != null) {
              await mostrarResultadoDesdeContexto(ctx);
            } else {
              print(
                  "[X] No se encontró un contexto válido para mostrar el resultado.");
            }
          } else {
            Navigator.of(contxt).pop();
            navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (_) => LikertSurveyPage()),
            );
          }
        } catch (e) {
          print("[X] Error al procesar flujo de RESULTADO: $e");
        }
      } else {
        print("[X] No se pudo obtener el ID de usuario para verificar estado.");
      }
    } else if (tipo == "RECORDATORIO_NO_EXAMEN") {
      // Asegurarte de ir al dashboard principal (en caso de estar en otra vista)
      Navigator.of(contxt).pop();
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => Dashboard()),
        (route) => false,
      );

      // Esperar brevemente a que se monte el widget antes de actuar
      await Future.delayed(const Duration(milliseconds: 400));

      final autoSamplingState = Dashboard.globalKey.currentState;
      if (autoSamplingState != null && autoSamplingState.mounted) {
        autoSamplingState.setState(() {
          autoSamplingState.irAPestanaPrincipal(); // Ir a la pestaña principal
        });
      } else {
        print("[X] No se pudo acceder al estado de AutoSamplingPageState.");
      }
    } else if (tipo == "RECORDATORIO_NO_ENTREGA_DISPOSITIVO") {
      final ctx = navigatorKey.currentContext;
      final userId = await secureStorage.read(key: "user_id");

      if (ctx != null && userId != null) {
        final confirmed = await mostrarDialogoEntregaDispositivo(ctx);
        Navigator.of(contxt).pop();
        if (confirmed) {
          final success =
              await PacienteService.desactivarRecordatorioEntrega(userId);
          if (success && ctx.mounted) {
            showSnackBar(ctx, "¡Gracias! Hemos detenido estos recordatorios.");
          }
        }
      }
    } else {
      Navigator.of(contxt).pop();
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const Resources()),
      );
    }
  }

  static Future<void> actualizarNotificacionesEnMemoria() async {
    final currentState = Notifications.globalKey.currentState;
    if (currentState != null && currentState.mounted) {
      final userId = await secureStorage.read(key: "user_id");
      if (userId != null) {
        await NotificationService.cargarYGuardarNotificaciones(userId);
        currentState.recargarDesdeExterior();
      } else {
        print(
            "[X] No se pudo obtener el ID de usuario para actualizar notificaciones.");
      }
    } else {
      print("⚠️ Notifications no está montado, guardamos solo en memoria.");
      NotificacionFlags.hayNotificacionNueva = true;
    }
  }

  static Future<bool> mostrarDialogoEntregaDispositivo(
      BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("¿Entregaste tu muestra?"),
            content: const Text(
                "Por favor confirma si ya entregaste el dispositivo de automuestreo."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text("Todavía no"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text("Sí, ya entregué"),
                
              ),
            ],
          ),
        ) ??
        false;
  }
}
