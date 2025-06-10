// ignore_for_file: use_build_context_synchronously
// showSnackBar guards calls on context with [mounted]

import 'package:chatbot/model/requests/dispositivo_request.dart';
import 'package:chatbot/model/requests/paciente_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/connectivity_service.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:chatbot/config/env.dart'; // Cambio de ambientes

final _log = Logger('PacienteService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
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
    bool hasInternet = await ConnectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        final publicId = await secureStorage.read(key: "user_id");
        final response = await getDio().put(
            "/paciente/registrar-dispositivo/$publicId",
            data: dispositivo.toJson());

        if (response.statusCode == 200) {
          showSnackBar(context, "Dispositivo registrado correctamente");
          secureStorage.delete(key: "pending_device");
          return true;
        }
      } on DioException catch (e) {
        _log.severe('Server connection error: $e');
        final errorMessage = e.response?.data["mensaje"];
        if (errorMessage != null) {
          showSnackBar(context, errorMessage.toString());
        } else {
          showSnackBar(context, "No se pudo registrar el dispositivo");
        }
      } catch (e) {
        _log.severe("Request failed: $e");
        showSnackBar(context, "Registro de dispositivo fallido");
      }

      return null;
    } else {
      secureStorage.write(key: "pending_device", value: "true");
      showSnackBar(context, "Dispositivo registrado correctamente");
      return true;
    }
  }

  static Future<bool> update(
      BuildContext context, PacienteRequest request) async {
    final id = await secureStorage.read(key: "user_id");
    try {
      final response =
          await getDio().put("/paciente/editar/$id", data: request.toJson());

      if (response.statusCode == 200) {
        _log.fine("User data updated");
        showSnackBar(context, "Datos actualizados correctamente");

        return true;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');
      final errorMessage = e.response?.data["mensaje"];
      if (errorMessage != null) {
        showSnackBar(context, errorMessage.toString());
      } else {
        showSnackBar(context, "Actualización fallida");
      }
    } catch (e) {
      _log.severe("Request failed: $e");

      if (context.mounted) {
        showSnackBar(context, 'Ocurrió un error inesperado.');
      }
    }
    return false;
  }

  static Future<PacienteRequest?> getPaciente(BuildContext context) async {
    final id = await secureStorage.read(key: "user_id");
    try {
      final response = await getDio().get("/paciente/usuario/$id");

      if (response.statusCode == 200) {
        final paciente = PacienteRequest.fromJson(response.data);

        return paciente;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');
      final errorMessage = e.response?.data["mensaje"];
      if (errorMessage != null) {
        showSnackBar(context, errorMessage.toString());
      } else {
        showSnackBar(context, "Error al obtener la información");
      }
    } catch (e) {
      _log.severe("Request failed: $e");

      if (context.mounted) {
        showSnackBar(context, 'Ocurrió un error inesperado.');
      }
    }

    return null;
  }
}
