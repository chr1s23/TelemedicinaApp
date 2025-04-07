import 'package:chatbot/model/requests/examen_vph_request.dart';

class SesionChatRequest {
  String cuentaPublicId;
  String inicio = DateTime.now().toIso8601String().split('.').first;
  String? fin;
  String? contenido;
  ExamenVphRequest? examenVph;

  SesionChatRequest(this.cuentaPublicId, this.fin, this.contenido);

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
