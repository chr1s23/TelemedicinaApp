class InfoSocioeconomicaResponse {
  String publicId;
  String? instruccion;
  String? ingresos;
  String? trabajoRemunerado;
  String? ocupacion;
  String? recibeBono;

  InfoSocioeconomicaResponse(
      {required this.publicId,
      this.instruccion,
      this.ingresos,
      this.trabajoRemunerado,
      this.ocupacion,
      this.recibeBono});

  factory InfoSocioeconomicaResponse.fromJsonMap(Map<String, dynamic> json) =>
      InfoSocioeconomicaResponse(
          publicId: json["publicId"],
          instruccion: json["instruccion"],
          ingresos: json["ingresos"],
          trabajoRemunerado: json["trabajoRemunerado"],
          ocupacion: json["ocupacion"],
          recibeBono: json["recibeBono"]);
}
