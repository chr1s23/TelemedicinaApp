
import 'package:chatbot/config/env.dart'; // Cambio de ambientes
import 'package:logger/logger.dart';
import 'package:chatbot/model/responses/examen_vph_response.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:chatbot/model/storage/storage.dart';


final _log = Logger();

class ResultadoService {
  static final String _baseUrl = AppConfig.baseUrl;
  static Future<ExamenVphResponse?> obtenerResultado(String publicId) async {
    final url = Uri.parse('$_baseUrl/prueba/admin/$publicId'); 
    final token = await secureStorage.read(key: 'user_token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return ExamenVphResponse.fromJson(data);
    } else {
      debugPrint('❌ Error al obtener resultado: ${response.statusCode}');
      return null;
    }
  }
}
