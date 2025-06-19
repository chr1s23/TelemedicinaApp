import 'package:dio/dio.dart';
import '../model/responses/ubicacion_response.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:logging/logging.dart';
import 'package:chatbot/config/env.dart'; // Cambio de ambientes

final _log = Logger('UbicacionService');
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

class UbicacionService {
  static const String _endpoint = '/api/ubicaciones'; 

  static Future<List<UbicacionResponse>> fetchUbicaciones({String? establecimiento}) async {
    try {
      final dio = getDio();

      final response = await dio.get(
        _endpoint,
        queryParameters: establecimiento != null ? {'establecimiento': establecimiento} : null,
      );

      if (response.statusCode == 200) {
        List<dynamic> body = response.data;

        return body.map((json) => UbicacionResponse.fromJson(json)).toList();
      } else {
        _log.warning('Error al cargar ubicaciones: ${response.statusCode}');
        throw Exception('Error al cargar ubicaciones');
      }
    } catch (e, stacktrace) {
      _log.severe('Excepción al cargar ubicaciones: $e', e, stacktrace);
      throw Exception('Excepción al cargar ubicaciones');
    }
  }
}
