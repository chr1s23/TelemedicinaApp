import 'package:chatbot/model/requests/inf_socioeconomica_request.dart';

class PacienteRequest {
  String nombre;
  String fechaNacimiento;
  String pais;
  String lenguaMaterna;
  String estadoCivil;
  String sexo;
  InfSocioeconomicaRequest? infoSocioeconomica;

  PacienteRequest(this.nombre, this.fechaNacimiento, this.pais, this.lenguaMaterna, this.estadoCivil, this.sexo, this.infoSocioeconomica);
}