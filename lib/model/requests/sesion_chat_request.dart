import 'package:chatbot/model/requests/examen_vph_request.dart';

class SesionChatRequest {
  String cuentaPublicId;
  String inicio = DateTime.now().toIso8601String().split('.').first;
  String? fin;
  String? contenido;
  ExamenVphRequest? examenVph;

  SesionChatRequest(this.cuentaPublicId, this.fin, this.contenido, this.inicio, this.examenVph);

  factory SesionChatRequest.fromJson(Map<String, dynamic> json) {
    return SesionChatRequest(
      json["cuentaPublicId"],
      json["fin"],
      json["contenido"],
      json["inicio"],
      ExamenVphRequest.fromJson(json["examenVph"])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cuentaPublicId": cuentaPublicId,
      "inicio": inicio,
      "fin": fin,
      "contenido": contenido,
      "examenVph": examenVph?.toJson()
    };
  }
}
