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

  static final Map<String, String> _lenguas = {
    "ESPAÑOL": "ESPANOL",
    "INGLÉS": "INGLES",
    "OTRO": "OTRO",
  };

  static final Map<String, String> _estadosCiviles = {
    "SOLTERO/A": "SOLTERO",
    "CASADO/A": "CASADO",
    "DIVORCIADO/A": "DIVORCIADO",
    "VIUDO/A": "VIUDO",
    "UNIÓN LIBRE": "UNION_LIBRE",
  };

  static final Map<String, String> _lenguasReverse = {
    "ESPANOL": "ESPAÑOL",
    "INGLES": "INGLÉS",
    "OTRO": "OTRO",
  };

  static final Map<String, String> _estadosCivilesReverse = {
    "SOLTERO": "SOLTERO/A",
    "CASADO": "CASADO/A",
    "DIVORCIADO": "DIVORCIADO/A",
    "VIUDO": "VIUDO/A",
    "UNION_LIBRE": "UNIÓN LIBRE",
  };

  Map<String, dynamic> toJson() {
    return {
      "nombre": nombre,
      "fechaNacimiento": fechaNacimiento,
      "pais": pais,
      "lenguaMaterna": _lenguas[lenguaMaterna],
      "estadoCivil": _estadosCiviles[estadoCivil],
      "sexo": sexo,
      "infoSocioeconomica": infoSocioeconomica?.toJson()
    };
  }

  static PacienteRequest fromJson(Map<String, dynamic> json) {
    return PacienteRequest(
      json["nombre"],
      json["fechaNacimiento"],
      json["pais"],
      _lenguasReverse[json["lenguaMaterna"]]!,
      _estadosCivilesReverse[json["estadoCivil"]]!,
      json["sexo"],
      InfSocioeconomicaRequest.fromJson(json["informacionSocioeconomica"]),
    );
  }
}
