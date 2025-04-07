import 'package:chatbot/model/responses/archivo_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger('ArchivoService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
    baseUrl: "https://clias.ucuenca.edu.ec",
    headers: {'Content-Type': 'application/json'},
  ));

  return _dio!;
}

sealed class ArchivoService {
  static Future<String?> getArchivo(
      BuildContext context, String nombre) async {
    try {
      final response = await getDio().get("/archivo/nombre/$nombre");

      if (response.statusCode == 200) {
        final archivoResponse = ArchivoResponse.fromJsonMap(response.data).contenido;

        _log.fine("Get file success: Name - $nombre");

        return archivoResponse;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('No se pudo obtener el archivo solicitado.')),
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
      _log.severe("Get file failed: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consulta de archivo fallido.'),
          ),
        );
      }
    }

    return null;
  }
}
