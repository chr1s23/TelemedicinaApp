import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatbot/model/responses/notificacion_response.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Para obtener info del dispositivo
import 'package:chatbot/config/env.dart'; // Cambio de ambientes
import 'package:logger/logger.dart';

final _log = Logger();

class NotificationService {
  static final String _baseUrl = AppConfig.baseUrl;

  static Future<List<NotificacionResponse>> fetchNotifications(
      String publicId) async {
    final token = await secureStorage.read(key: "user_token");
    if (token == null) {
      throw Exception("Token JWT no disponible");
    }

    final uri = Uri.parse("$_baseUrl/notificaciones/$publicId");
    final response = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => NotificacionResponse.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener notificaciones");
    }
  }

  static Future<void> marcarNotificacionComoLeida(String publicId) async {
    final token = await secureStorage.read(key: "user_token");
    if (token == null) {
      throw Exception("Token JWT no disponible");
    }

    final uri = Uri.parse("$_baseUrl/notificaciones/$publicId/marcar-leida");
    final response = await http.put(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    print("🔄 PUT marcar-leida statusCode = ${response.statusCode}");
    print("📦 Response body: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("No se pudo marcar como leída la notificación");
    }
  }

// Registrar dispositivo y token FCM en el backend
  static Future<void> registrarTokenFCM(String cuentaUsuarioPublicId) async {
    final tokenJWT = await secureStorage.read(key: "user_token");
    if (tokenJWT == null) {
      _log.w("Token JWT no disponible");
      throw Exception("Token JWT no disponible");
    }

    // Solicitar permiso de notificación
    await FirebaseMessaging.instance.requestPermission();

    // Obtener token FCM
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) {
      _log.e("[X] No se pudo obtener el token FCM");
      throw Exception("No se pudo obtener el token FCM");
    }

    final uri = Uri.parse("$_baseUrl/dispositivo");

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $tokenJWT",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "usuarioPublicId": cuentaUsuarioPublicId,
        "fcmToken": fcmToken,
      }),
    );

    if (response.statusCode != 200) {
      _log.e("[X] Error registrando el dispositivo: ${response.body}");
      throw Exception("Error al registrar dispositivo");
    }

    _log.i("[OK] Token FCM registrado con éxito");
  }
}
