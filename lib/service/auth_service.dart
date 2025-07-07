// ignore_for_file: use_build_context_synchronously
// showSnackBar guards calls on context with [mounted]

import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/model/responses/user_response.dart';
import 'package:chatbot/service/notification_service.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/config/env.dart'; // Cambio de ambientes

final _log = Logger('AuthService');
Dio? _dio;

Dio getDio() {
  _dio ??= Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  return _dio!;
}

sealed class AuthService {
  static Future<UserResponse?> login(BuildContext context, User user) async {
    print("🔄 POST /usuarios/autenticar");
    try {
      final response = await getDio().post("/usuarios/autenticar", data: {
        "nombreUsuario": user.nombreUsuario,
        "contrasena": user.contrasena,
        "appVersion": AppConfig.appVersion,
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

        String? autoPlay = await secureStorage.read(key: "auto_play");

        if (autoPlay == null) {
          secureStorage.write(key: "auto_play", value: "on");
        }

        return userResponse;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');
      showSnackBar(context, "Usuario o contraseña incorrectos");
    } catch (e) {
      _log.severe("Login failed: $e");
      showSnackBar(context, "Inicio de sesión fallido");
    }

    return null;
  }

  static Future<UserResponse?> signUp(
      BuildContext context, UserRequest user) async {
    try {
      var request = user.toJson();
      print("El usuario a registrar es: $request");
      final response = await getDio().post("/usuarios/registro", data: request);
      if (response.statusCode == 200) {
        UserResponse userResponse = UserResponse.fromJsonMap(response.data);
        
        secureStorage.write(key: "user_id", value: userResponse.publicId);
        secureStorage.write(key: "user_token", value: userResponse.token);
        secureStorage.write(
            key: "user_device", value: userResponse.dispositivo);
        secureStorage.write(key: "auto_play", value: "on");
        /**
         * Agrega el token del dispositivo del usuario y manda
         * notificación de bienvenida
         */
        await NotificationService.registrarTokenFCM(userResponse.publicId);
        await NotificationService.crearNotificacionBienvenida(userResponse.publicId);

        print("🔐 Guardado en storage: ID - ${userResponse.publicId} | Token - ${userResponse.token}");
        

        return userResponse;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');
      final errorMessage = e.response?.data["mensaje"];
      if (errorMessage != null) {
        showSnackBar(context, errorMessage.toString());
      } else {
        showSnackBar(context, "No se pudo registrar el usuario");
      }
    } catch (e) {
      _log.severe("Signup failed: $e");
      showSnackBar(context, "Registro de usuario fallido");
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
      showSnackBar(context, "Tu sesión ha caducado. Vuelve a iniciar sesión.");
    }
    return null;
  }

  static Future<bool> changePassword(BuildContext context, User user, String fecha) async {
    try {
      final response =
          await getDio().put("/usuarios/cambiar-contrasena", data: {
        "nombreUsuario": user.nombreUsuario,
        "contrasena": user.contrasena,
        "fechaNacimientoCambioPass": fecha //dd/MM/yyyy
      });

      if (response.statusCode == 200) {
        _log.fine("Password changed sucess: User - ${user.nombreUsuario} ");
        showSnackBar(context, "Contraseña cambiada correctamente");
        return true;
      }
    } on DioException catch (e) {
      _log.severe('Server connection error: $e');
      final errorMessage = e.response?.data["mensaje"];
      if (errorMessage != null) {
        showSnackBar(context, errorMessage.toString());
      } else {
        showSnackBar(context, "No se pudo cambiar la contraseña");
      }
    } catch (e) {
      _log.severe("Password change failed: $e");

      showSnackBar(context, "Cambio de contraseña fallido");
    }
    return false;
  }
}
