import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chatbot/model/responses/notificacion_response.dart';
import 'package:chatbot/model/storage/storage.dart';

class NotificationService {
  static const String _baseUrl =
      "https://clias.ucuenca.edu.ec"; // cambia si es necesario

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
}
