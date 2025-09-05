class EncuestaSusRequest {
  final List<int> respuestas;
  final String cuentaUsuarioId;

  EncuestaSusRequest(this.respuestas, this.cuentaUsuarioId);

  Map<String, dynamic> toJson() {
    return {
      "respuestas": respuestas,
      "cuentaUsuarioId": cuentaUsuarioId,
    };
  }
}
