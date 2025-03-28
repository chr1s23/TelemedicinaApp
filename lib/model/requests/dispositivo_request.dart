class DispositivoRequest {
  String dispositivo;

  DispositivoRequest(this.dispositivo);

  Map<String, dynamic> toJson() {
    return {"dispositivo": dispositivo};
  }
}
