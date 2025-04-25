import 'dart:convert';

import 'package:chatbot/model/requests/sesion_chat_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/connectivity_service.dart';
import 'package:chatbot/view/widgets/utils.dart';
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
    bool hasInternet = await ConnectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        final response =
            await getDio().post("/sesion-chat/usuario", data: sesion.toJson());

        if (response.statusCode == 200 && context.mounted) {
          showSnackBar(
              context, 'Proceso de Automuestreo terminado correctamente!.');
          secureStorage.delete(key: "form_request");
          return true;
        } else {
          if (context.mounted) {
            showSnackBar(context,
                'No se pudo registrar la información del Automuestreo VPH');
          }
        }
      } on DioException catch (e) {
        _log.severe('Server connection error: $e');

        if (context.mounted) {
          showSnackBar(context, 'Ocurrió un error inesperado.');
        }
      } catch (e) {
        _log.severe("Login failed: $e");

        if (context.mounted) {
          showSnackBar(context, 'Registro de examen VPH fallido');
        }
      }

      return null;
    } else {
      _log.warning("Writing form information to pending request");
      secureStorage.write(
          key: "form_request", value: jsonEncode(sesion));
      if (context.mounted) {
        showSnackBar(
            context, 'Proceso de Automuestreo terminado correctamente!.');
      }
      return true;
    }
  }
}
