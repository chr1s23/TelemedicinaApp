class SaludSexualRequest {
  bool estaEmbarazada;
  String fechaUltimaMenstruacion;
  String ultimoExamenPap;
  String tiempoPruebaVph;
  int numParejasSexuales;
  String tieneEts;
  String? nombreEts;
  String enfermedadAutoinmune;
  String? nombreAutoinmune;

  SaludSexualRequest(
      this.estaEmbarazada,
      this.fechaUltimaMenstruacion,
      this.ultimoExamenPap,
      this.tiempoPruebaVph,
      this.numParejasSexuales,
      this.tieneEts,
      this.nombreEts,
      this.enfermedadAutoinmune,
      this.nombreAutoinmune);

  Map<String, String> rangoTiempo = {
    "Menos de 1 año": "MENOS_1_ANIO",
    "De 1 a 3 años": "DE_1_A_3_ANIOS",
    "Más 3 años": "MAS_3_ANIOS",
    "Nunca": "NUNCA"
  };

  Map<String, String> opciones = {
    "No": "NO",
    "Nose": "NOSE",
    "Si": "SI"
  };

  Map<String, dynamic> toJson() {
    return {
      "estaEmbarazada": estaEmbarazada,
      "fechaUltimaMenstruacion": fechaUltimaMenstruacion,
      "ultimoExamenPap": rangoTiempo[ultimoExamenPap],
      "tiempoPruebaVph": rangoTiempo[tiempoPruebaVph],
      "numParejasSexuales": numParejasSexuales,
      "tieneEts": opciones[tieneEts],
      "nombreEts": nombreEts,
      "enfermedadAutoinmune": opciones[enfermedadAutoinmune],
      "nombreAutoinmune": nombreAutoinmune
    };
  }
}
