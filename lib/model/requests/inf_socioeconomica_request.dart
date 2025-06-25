class InfSocioeconomicaRequest {
  String? instruccion;
  String? ingresos;
  String? trabajoRemunerado;
  String? ocupacion;
  String? recibeBono;

  InfSocioeconomicaRequest(this.instruccion, this.ingresos,
      this.trabajoRemunerado, this.ocupacion, this.recibeBono);

  static final Map<String, String> _nivelInstruccion = {
    "NINGUNO": "NINGUNO",
    "PRIMARIA": "PRIMARIA",
    "SECUNDARIA": "SECUNDARIA",
    "UNIVERSITARIA": "UNIVERSITARIA",
    "CENTRO DE ALBAFETIZACIÓN": "CENTRO_DE_ALFABETIZACION"
  };

  static final Map<String, String> _nivelIngresos = {
    "Menos de \$450": "MENOR_450",
    "\$450 - \$900": "ENTRE_450_900",
    "\$901 - \$1350": "ENTRE_901_1350",
    "Más de \$1350": "MAYOR_1350"
  };

  static final Map<String, String> _nivelInstruccionReverse = {
    "NINGUNO": "NINGUNO",
    "PRIMARIA": "PRIMARIA",
    "SECUNDARIA": "SECUNDARIA",
    "UNIVERSITARIA": "UNIVERSITARIA",
    "CENTRO_DE_ALFABETIZACION": "CENTRO DE ALBAFETIZACIÓN"
  };

  static final Map<String, String> _nivelIngresosReverse = {
    "MENOR_450": "Menos de \$450",
    "ENTRE_450_900": "\$450 - \$900",
    "ENTRE_901_1350": "\$901 - \$1350",
    "MAYOR_1350": "Más de \$1350"
  };

  Map<String, dynamic> toJson() {
    return {
      "instruccion": _nivelInstruccion[instruccion ?? ""],
      "ingresos": _nivelIngresos[ingresos ?? ""],
      "trabajoRemunerado": trabajoRemunerado,
      "ocupacion": ocupacion,
      "recibeBono": recibeBono
    };
  }

  static InfSocioeconomicaRequest? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return InfSocioeconomicaRequest(
      _nivelInstruccionReverse[json["instruccion"]],
      _nivelIngresosReverse[json["ingresos"]],
      json["trabajoRemunerado"],
      json["ocupacion"],
      json["recibeBono"]
    );
  }
}
