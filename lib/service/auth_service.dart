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
        secureStorage.write(
            key: "user_device", value: userResponse.dispositivo);

        User.setCurrentUser(User(userResponse.nombre,
            userResponse.nombreUsuario, "*****", userResponse.dispositivo));

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
          SnackBar(content: Text('Usuario o contraseña incorrectos')),
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
      if (response.statusCode == 200) {
        UserResponse userResponse = UserResponse.fromJsonMap(response.data);

        secureStorage.write(key: "user_id", value: userResponse.publicId);
        secureStorage.write(key: "user_token", value: userResponse.token);
        secureStorage.write(
            key: "user_device", value: userResponse.dispositivo);

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

  static Future<String?> refreshToken(
      BuildContext context, String token) async {
    try {
      final localDio = getDio();

      localDio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['token'] = token;
          return handler.next(options);
        },
      ));

      final valid = await localDio.get("/usuarios/validar");
      if (valid.statusCode == 200) {
        _log.fine("Validate token sucess");

        return valid.data;
      }
    } catch (e) {
      _log.severe("Validate token failed: $e");
      if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Tu sesión ha caducado.')),
          );
        }
    }
    return null;
  }

  static Future<dynamic> changePassword(BuildContext context, User user) async {
    try {
      final response =
          await getDio().put("/usuarios/cambiar-contrasena", data: {
        "nombreUsuario": user.nombreUsuario,
        "contrasena": user.contrasena,
      });

      if (response.statusCode == 200) {
        _log.fine("Password changed sucess: User - ${user.nombreUsuario} ");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contraseña cambiada correctamente.')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verifique el nombre de usuario.')),
          );
        }
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cambiar la contraseña.')),
        );
      }
    } catch (e) {
      _log.severe("Login failed: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cambio de contraseña fallido'),
          ),
        );
      }
    }
  }
}
