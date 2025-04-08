import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger('SesionChatService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
      baseUrl: "https://clias.ucuenca.edu.ec",
      headers: {'Content-Type': 'application/json'}));

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

sealed class SesionChatService {
  static Future<bool?> registrarInfoExamen(
      BuildContext context, SesionChatRequest sesion) async {
    try {
      final response =
          await getDio().post("/sesion-chat/usuario", data: sesion.toJson());

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Proceso de Automuestreo terminado correctamente!.')),
          );
        }
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'No se pudo registrar la información del Automuestreo VPH')),
          );
        }
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocurrió un error inesperado.')),
        );
      }
    } catch (e) {
      _log.severe("Login failed: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro de examen VPH fallido'),
          ),
        );
      }
    }

    return null;
  }
}
