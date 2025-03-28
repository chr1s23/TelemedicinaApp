import 'package:chatbot/model/requests/salud_sexual_request.dart';

class ExamenVphRequest {
  String fecha;
  String dispositivo;
  SaludSexualRequest saludSexual;

  ExamenVphRequest(this.fecha, this.dispositivo, this.saludSexual);

  Map<String, dynamic> toJson() {
    return {
      "fecha": fecha,
      "dispositivo": dispositivo,
      "saludSexual": saludSexual.toJson()
    };
  }
}
