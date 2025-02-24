import 'package:chatbot/model/requests/paciente_request.dart';

class UserRequest {
  String nombreUsuario;
  String contrasena;
  String rol = "USER";
  bool aceptaConsentimiento = false;
  PacienteRequest paciente;

  UserRequest(this.nombreUsuario, this.contrasena, this.rol, this.aceptaConsentimiento, this.paciente);
}