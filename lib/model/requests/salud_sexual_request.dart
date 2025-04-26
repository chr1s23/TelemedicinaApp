class SaludSexualRequest {
  bool estaEmbarazada = false;
  String? fechaUltimaMenstruacion;
  String? ultimoExamenPap;
  String? tiempoPruebaVph;
  int? numParejasSexuales;
  String? tieneEts;
  String? nombreEts;

  SaludSexualRequest(
      this.estaEmbarazada,
      this.fechaUltimaMenstruacion,
      this.ultimoExamenPap,
      this.tiempoPruebaVph,
      this.numParejasSexuales,
      this.tieneEts,
      this.nombreEts);

  Map<String, String> rangoTiempo = {
    "Menos de 1 año": "MENOS_1_ANIO",
    "De 1 a 3 años": "DE_1_A_3_ANIOS",
    "Más 3 años": "MAS_3_ANIOS",
    "Nunca": "NUNCA"
  };

  Map<String, String> opciones = {"No": "NO", "Nose": "NOSE", "Si": "SI"};

  static final Map<String, String> opcionesReverse = {"NO": "No", "NOSE": "Nose", "SI": "Si"};

  factory SaludSexualRequest.fromJson(Map<String, dynamic> json) {
    return SaludSexualRequest(
        json["estaEmbarazada"],
        json["fechaUltimaMenstruacion"],
        json["ultimoExamenPap"],
        json["tiempoPruebaVph"],
        json["numParejasSexuales"],
        opcionesReverse[json["tieneEts"]],
        json["nombreEts"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "estaEmbarazada": estaEmbarazada,
      "fechaUltimaMenstruacion": fechaUltimaMenstruacion,
      "ultimoExamenPap": ultimoExamenPap,
      "tiempoPruebaVph": tiempoPruebaVph,
      "numParejasSexuales": numParejasSexuales,
      "tieneEts": opciones[tieneEts],
      "nombreEts": nombreEts
    };
  }
}
