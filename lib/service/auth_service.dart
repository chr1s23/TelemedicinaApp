import 'dart:io';

import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/model/responses/user_response.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger('AuthService');
Dio? _dio;

void configureDio(Dio dio) {
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
}

Dio getDio() {
  if (_dio == null) {
    _dio = Dio(BaseOptions(
      baseUrl: "https://clias.ucuenca.edu.ec",
      headers: {'Content-Type': 'application/json'},
    ));

    configureDio(_dio!);
  }

  return _dio!;
}

sealed class AuthService {
  static Future<UserResponse?> login(BuildContext context, User user) async {
    try {
      final response = await getDio().post("/usuarios/autenticar", data: {
        "nombreUsuario": user.nombreUsuario,
        "contrasena": user.contrasena,
      });

      if (response.statusCode == 200) {
        return UserResponse.fromJsonMap(response.data);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario o contraseña incorrectos')),
          );
        }
      }
    } on DioException catch (e) {
      _log.severe("Error de Dio: ${e.message}");
      _log.severe("Código de error: ${e.response?.statusCode}");
      _log.severe("Respuesta del servidor: ${e.response?.data}");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión con el servidor')),
        );
      }
    } catch (e) {
      _log.severe(e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión fallido'),
          ),
        );
      }
    }
    return null;
  }

  static Future<UserResponse?> signUp(BuildContext context, UserRequest user) async {
    try {
      final response = await getDio().post("/usuarios/registro", data: user);

      if (response.statusCode == 200) {
        UserResponse userResponse = UserResponse.fromJsonMap(response.data);
        return userResponse;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo registrar el usuario'),
            ),
          );
        }
      }
    } on DioException catch (e) {
      _log.severe(e.message);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro de usuario fallido'),
          ),
        );
      }
    }
    return null;
  }
}
