import 'package:chatbot/model/requests/inf_socioeconomica_request.dart';
import 'package:chatbot/model/responses/info_socioeconomica_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class InfSocioeconomicaService {
  final dio = Dio(BaseOptions(
      baseUrl: "https://clias.ucuenca.edu.ec",
      headers: {'Content-Type': 'application/json'}));

  Future<InfoSocioeconomicaResponse?> getInformacion(BuildContext context, String publicId) async {
    try {
      final response = await dio.get("/info-socioeconomica/usuario/$publicId");

      if (response.statusCode == 200) {
        final infoResponse = InfoSocioeconomicaResponse.fromJsonMap(response.data);
        return infoResponse;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo obtener la información del usuario'),
            ),
          );
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud de información fallida'),
          ),
        );
      }
    }
    return null;
  }

  Future<bool?> editarInformacion(BuildContext context, InfSocioeconomicaRequest informacion, String publicId) async {
    try {
      final response = await dio.put("/info-socioeconomica/editar/$publicId", data: informacion);

      if (response.statusCode == 200) {
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo editar la información del usuario'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Edición de información fallido'),
          ),
        );
      }
    }
    return null;
  }
}
