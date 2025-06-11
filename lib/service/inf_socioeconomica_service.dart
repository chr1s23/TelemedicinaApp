import 'package:chatbot/model/requests/inf_socioeconomica_request.dart';
import 'package:chatbot/model/responses/info_socioeconomica_response.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:chatbot/config/env.dart'; // Cambio de ambientes


final _log = Logger('InfoSocioService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
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

sealed class InfSocioeconomicaService {
  static Future<InfoSocioeconomicaResponse?> getInformacion(
      BuildContext context, String publicId) async {
    try {
      final response =
          await getDio().get("/info-socioeconomica/usuario/$publicId");

      if (response.statusCode == 200) {
        final infoResponse =
            InfoSocioeconomicaResponse.fromJsonMap(response.data);
        return infoResponse;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');
      final errorMessage = e.response?.data["mensaje"];
      if (context.mounted) {
        if (errorMessage != null) {
          showSnackBar(context, errorMessage.toString());
        } else {
          showSnackBar(
              context, "No se pudo obtener la información del usuario");
        }
      }
    } catch (e) {
      _log.severe("Request failed: $e");
      if (context.mounted) {
        showSnackBar(context, 'Solicitud de información fallida');
      }
    }
    return null;
  }

  static Future<bool?> editarInformacion(BuildContext context,
      InfSocioeconomicaRequest informacion, String publicId) async {
    try {
      final response = await getDio().put(
          "/info-socioeconomica/editar/$publicId",
          data: informacion.toJson());

      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');
      final errorMessage = e.response?.data["mensaje"];
      if (context.mounted) {
        if (errorMessage != null) {
          showSnackBar(context, errorMessage.toString());
        } else {
          showSnackBar(context, "No se pudo editar la información del usuario");
        }
      }
    } catch (e) {
      _log.severe("Request failed: $e");
      if (context.mounted) {
        showSnackBar(context, 'Edición de información fallido');
      }
    }
    return null;
  }
}
