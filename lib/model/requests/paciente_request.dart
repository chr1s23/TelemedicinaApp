import 'package:chatbot/model/requests/inf_socioeconomica_request.dart';

class PacienteRequest {
  String nombre;
  String fechaNacimiento;
  String pais;
  String lenguaMaterna;
  String estadoCivil;
  String sexo;
  InfSocioeconomicaRequest? infoSocioeconomica;

  PacienteRequest(this.nombre, this.fechaNacimiento, this.pais,
      this.lenguaMaterna, this.estadoCivil, this.sexo, this.infoSocioeconomica);

  Map<String, String> lenguas = {
    "ESPAÑOL": "ESPANOL",
    "INGLÉS": "INGLES",
    "OTRO": "OTRO",
  };

  Map<String, String> estadosCiviles = {
    "SOLTERO/A": "SOLTERO",
    "CASADO/A": "CASADO",
    "DIVORCIADO/A": "DIVORCIADO",
    "VIUDO/A": "VIUDO",
    "UNIÓN LIBRE": "UNION_LIBRE",
  };

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "fechaNacimiento": fechaNacimiento,
      "pais": pais,
      "lenguaMaterna": lenguas[lenguaMaterna],
      "estadoCivil": estadosCiviles[estadoCivil],
      "sexo": sexo,
      "infoSocioeconomica": infoSocioeconomica?.toJson()
    };
  }
}
