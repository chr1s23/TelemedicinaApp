class SesionChatRequest{
    String cuentaPublicId;
    String inicio;
    String fin;
    String? contenido;
    ExamenVphRequest? examenVph;

    SesionChatRequest(this.cuentaPublicId, this.inicio, this.fin, this.contenido);

    Map<String, dynamic> toJson() {
        return {
            "cuentaPublicId": cuentaPublicId,
            "inicio": inicio,
            "fin": fin,
            "contenido": contenido?,
            "examenVph": examenVph?.toJson()
        };
    }

}