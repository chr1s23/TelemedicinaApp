import 'package:http/http.dart' as http;
import 'package:chatbot/config/env.dart'; // Cambio de ambientes
import 'package:chatbot/model/storage/storage.dart'; // Para obtener el token desde almacenamiento seguro
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final _log = Logger();

class ResourceService {
  static final String _baseUrl = AppConfig.baseUrl;

  Future<void> incrementarVista(String codigo) async {
    final url = Uri.parse("$_baseUrl/api/recursos/aumentar-vista?codigo=$codigo");


    // Obtener el token de acceso desde el almacenamiento seguro
    final token = await secureStorage.read(key: 'user_token');
    print('Token de acceso: $token');  // Aquí se imprime el token

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // Verificar la respuesta del servidor
    if (response.statusCode == 200) {
  print('Vista incrementada para el recurso $codigo');
} else {
  print('Error al incrementar vistas, código de estado: ${response.statusCode}');
  print('Cuerpo de la respuesta: ${response.body}');
}

  }
}
