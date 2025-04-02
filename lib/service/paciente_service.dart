import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger('PacienteService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
    baseUrl: "https://clias.ucuenca.edu.ec",
    headers: {'Content-Type': 'application/json'},
  ));

  // Agregar interceptor para incluir el token en cada petición
  _dio!.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String token = await secureStorage.read(key: "user_token") ?? "";

      options.headers['Authorization'] = "Bearer $token";
      return handler.next(options);
    },
  ));

  return _dio!;
}

sealed class PacienteService {
  static Future<bool?> registrarDispositivo(
      BuildContext context, DispositivoRequest dispositivo) async {
    try {
      final publicId = await secureStorage.read(key: "user_id");
      final response = await getDio().put("/paciente/registrar-dispositivo/$publicId",
          data: dispositivo.toJson());

      if (response.statusCode == 200) {
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo registrar el dispositivo')),
          );
        }
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión con el servidor')),
        );
      }
    } catch (e) {
      _log.severe("Login failed: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro de dispositivo fallido'),
          ),
        );
      }
    }

    return null;
  }
}
