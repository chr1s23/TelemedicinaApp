class InfSocioeconomicaRequest {
  String? instruccion;
  String? ingresos;
  String? trabajoRemunerado;
  String? ocupacion;
  String? recibeBono;

  InfSocioeconomicaRequest(this.instruccion, this.ingresos,
      this.trabajoRemunerado, this.ocupacion, this.recibeBono);

  Map<String, String> nivelInstruccion = {
    "NINGUNO": "NINGUNO",
    "PRIMARIA": "PRIMARIA",
    "SECUNDARIA": "SECUNDARIA",
    "UNIVERSITARIA": "UNIVERSITARIA",
    "CENTRO DE ALBAFETIZACIÓN": "CENTRO_DE_ALFABETIZACION"
  };

  Map<String, String> nivelIngresos = {
    "Menos de \$450": "MENOR_450",
    "\$450 - \$900": "ENTRE_450_900",
    "\$901 - \$1350": "ENTRE_901_1350",
    "Más de \$1350": "MAYOR_1350"
  };

  Map<String, dynamic> toJson() {
    return {
      "instruccion": nivelInstruccion[instruccion ?? ""],
      "ingresos": nivelIngresos[ingresos ?? ""],
      "trabajoRemunerado": trabajoRemunerado,
      "ocupacion": ocupacion,
      "recibeBono": recibeBono
    };
  }

  static InfSocioeconomicaRequest? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return InfSocioeconomicaRequest(
      json["instruccion"],
      json["ingresos"],
      json["trabajoRemunerado"],
      json["ocupacion"],
      json["recibeBono"]
    );
  }
}
