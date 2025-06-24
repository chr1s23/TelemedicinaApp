import 'package:dio/dio.dart';
import 'package:chatbot/config/env.dart';
import 'package:chatbot/model/requests/encuesta_sus_request.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:logging/logging.dart';

final _log = Logger('EncuestaService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  _dio!.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String token = await secureStorage.read(key: "user_token") ?? "";
      options.headers['Authorization'] = "Bearer $token";
      return handler.next(options);
    },
  ));

  return _dio!;
}

class EncuestaService {
  static const String _endpoint = '/api/encuesta_sus';

  static Future<bool> guardarEncuesta(EncuestaSusRequest request) async {
    try {
      final dio = getDio();

      final response = await dio.post(
        _endpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        _log.warning('Error al guardar encuesta: ${response.statusCode}');
        return false;
      }
    } catch (e, stacktrace) {
      _log.severe('Excepción al guardar encuesta: $e', e, stacktrace);
      return false;
    }
  }
}
