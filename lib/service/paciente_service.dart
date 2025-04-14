// ignore_for_file: use_build_context_synchronously
// showSnackBar guards calls on context with [mounted]

import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/model/requests/paciente_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/view/widgets/utils.dart';
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
        showSnackBar(context, "Dispositivo registrado correctamente");
        return true;
      } else {
        showSnackBar(context, "No se pudo registrar el dispositivo");
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');

      showSnackBar(context, "Ocurrió un error inesperado");
    } catch (e) {
      _log.severe("Login failed: $e");

      showSnackBar(context, "Registro de dispositivo fallido");
    }

    return null;
  }

  static Future<bool> update(BuildContext context, PacienteRequest request) async {
    final id = await secureStorage.read(key: "user_id");
    try {
      final response = await getDio().put("/paciente/editar/$id", data: request.toJson());

      if (response.statusCode == 200) {
        _log.fine("User data updated");
        
        
        showSnackBar(context, "Datos actualizados correctamente");

        return true;
      } else {
        _log.severe("User data update failed: ${response.data}");

        showSnackBar(context, "Actualización fallida");

        return false;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');

      showSnackBar(context, "Ocurrió un error inesperado");

      return false;
    }
  }

  static Future<PacienteRequest?> getPaciente(BuildContext context) async {
    final id = await secureStorage.read(key: "user_id");
    try {
      final response = await getDio().get("/paciente/usuario/$id");

      if (response.statusCode == 200) {
        final paciente = PacienteRequest.fromJsonMap(response.data);

        return paciente;
      } else {
        _log.severe("Paciente data update failed: ${response.data}");

        showSnackBar(context, "Error al obtener la información");
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');

      showSnackBar(context, "Error de conexión con el servidor");
    }

    return null;
  }
}
