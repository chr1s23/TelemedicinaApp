import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:chatbot/model/storage/storage.dart';

final _log = Logger('SesionChatService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
      baseUrl: "https://clias.ucuenca.edu.ec",
      headers: {'Content-Type': 'application/json'},
      //TODO: Agregar el token de autenticacion como header con inicio Bearer ey....
    ));

  return _dio!;
}

sealed class SesionChatService {
  static Future<bool??> registrarInfoExamen(BuildContext context, SesionChatRequest sesion) async {
    try {
      final response = await getDio().post("/sesion-chat/usuario", data: sesion.toJson());

      if (response.statusCode == 200) {
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo registrar la información del examen VPH')),
          );
        }
      }
    } on DioException catch(e) {
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
            content: Text('Registro de examen VPH fallido'),
          ),
        );
      }
    }
    
    return null;
  }
}
