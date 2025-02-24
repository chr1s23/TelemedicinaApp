import 'package:chatbot/model/requests/user.dart';
import 'package:chatbot/model/requests/user_request.dart';
import 'package:chatbot/model/responses/user_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  String serviceUrl = "https://2c86-179-49-41-121.ngrok-free.app";
  
  Future<UserResponse?> login(BuildContext context, User user) async {
    try {
      final Uri uri = Uri.parse("$serviceUrl/usuarios/autenticar");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contrasena': user.contrasena,
          'nombreUsuario': user.nombreUsuario,
        }),
      );

      if (response.statusCode == 200) {
        UserResponse user = json.decode(response.body);
        return user;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo iniciar sesión'),
            ),
          );
        }
        return null;
      }
    } catch (e) {
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

  Future<UserResponse?> signUp(BuildContext context, UserRequest user) async {
    try {
      final Uri uri = Uri.parse("$serviceUrl/usuarios/registro");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "nombreUsuario": user.nombreUsuario,
          "contrasena": user.contrasena,
          "rol": user.rol,
          "aceptaConsentimiento": user.aceptaConsentimiento,
          "paciente": {
            "nombre": user.paciente.nombre,
            "fechaNacimiento": user.paciente.fechaNacimiento,
            "pais": user.paciente.pais,
            "lenguaMaterna": user.paciente.lenguaMaterna,
            "estadoCivil": user.paciente.estadoCivil,
            "sexo": user.paciente.sexo,
            "infoSocioeconomica": {
              //opcional puede ser nulo
              "instruccion": user.paciente.infoSocioeconomica?.instruccion,
              "ingresos": user.paciente.infoSocioeconomica?.ingresos,
              "trabajoRemunerado":
                  user.paciente.infoSocioeconomica?.trabajoRemunerado,
              "ocupacion": user.paciente.infoSocioeconomica?.ocupacion,
              "recibeBono": user.paciente.infoSocioeconomica?.recibeBono
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        UserResponse user = json.decode(response.body);
        return user;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo registrar el usuario'),
            ),
          );
        }
      }
    } catch (e) {
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
