class ArchivoResponse {
  String publicId;
  String nombre;
  String contenido;

  ArchivoResponse(this.publicId, this.nombre, this.contenido);

  factory ArchivoResponse.fromJsonMap(Map<String, dynamic> json) =>
      ArchivoResponse(json["publicId"], json["nombre"], json["contenido"]);
}
