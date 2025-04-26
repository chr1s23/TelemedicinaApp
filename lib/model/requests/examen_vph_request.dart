import 'package:chatbot/model/requests/salud_sexual_request.dart';

class ExamenVphRequest {
  String fecha = DateTime.now().toIso8601String().split('.').first;
  String dispositivo;
  SaludSexualRequest saludSexual;

  ExamenVphRequest(this.dispositivo, this.saludSexual, this.fecha);

  factory ExamenVphRequest.fromJson(Map<String, dynamic> json) {
    return ExamenVphRequest(json["dispositivo"],
        SaludSexualRequest.fromJson(json["saludSexual"]), json["fecha"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "fecha": fecha,
      "dispositivo": dispositivo,
      "saludSexual": saludSexual.toJson()
    };
  }
}
