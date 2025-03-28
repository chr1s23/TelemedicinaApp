import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/model/responses/user_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:chatbot/model/storage/storage.dart';

final _log = Logger('AuthService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
    baseUrl: "https://clias.ucuenca.edu.ec",
    headers: {'Content-Type': 'application/json'},
  ));

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
        final userResponse = UserResponse.fromJsonMap(response.data);

        secureStorage.write(key: "user_id", value: userResponse.publicId);
        secureStorage.write(key: "user_token", value: userResponse.token);

        _log.fine(
            "Saved to storage: ID - ${userResponse.publicId} | Token - ${userResponse.token}");

        return userResponse;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario o contraseña incorrectos')),
          );
        }
      }
    } on DioException catch (e) {
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
            content: Text('Inicio de sesión fallido'),
          ),
        );
      }
    }

    return null;
  }

  static Future<UserResponse?> signUp(
      BuildContext context, UserRequest user) async {
    try {
      var request = user.toJson();
      _log.fine(request);
      final response = await getDio().post("/usuarios/registro", data: request);
      _log.fine(response);
      if (response.statusCode == 200) {
        UserResponse userResponse = UserResponse.fromJsonMap(response.data);

        secureStorage.write(key: "user_id", value: userResponse.publicId);
        secureStorage.write(key: "user_token", value: userResponse.token);

        return userResponse;
      } else {
        _log.severe(
            "Unexpected server response during signup: ${response.data}");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo registrar el usuario'),
            ),
          );
        }
      }
    } catch (e) {
      _log.severe("Signup failed: $e");
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
