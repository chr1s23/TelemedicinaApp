import 'package:chatbot/config/env.dart';
import 'package:chatbot/model/requests/paciente_request.dart';

UserRequest? _userRequest;

class UserRequest {
  String nombreUsuario;
  String contrasena;
  String rol = "USER";
  bool aceptaConsentimiento = false;
  PacienteRequest paciente;

  UserRequest(this.nombreUsuario, this.contrasena, this.rol, this.aceptaConsentimiento, this.paciente);

  static UserRequest? getUserRequest() => _userRequest;
  static setUserRequest(UserRequest userRequest) => _userRequest = userRequest;

  Map<String, dynamic> toJson() {
    return {
      "nombreUsuario": nombreUsuario,
      "contrasena": contrasena,
      "appVersion": AppConfig.appVersion,
      "rol": rol,
      "aceptaConsentimiento": aceptaConsentimiento,
      "paciente": paciente.toJson()
    };
  }
}