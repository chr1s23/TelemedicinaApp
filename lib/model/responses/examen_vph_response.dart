import 'dart:convert';
class ExamenVphResponse {
  final String publicId;
  final String fechaExamen;
  final String? fechaResultado;
  final String dispositivo;
  final String? tipo;
  final int? tamano;
  final String? nombre;
  final String? diagnostico;
  final List<String> genotipos;
  final List<int>? contenido; // Aquí va el PDF como lista de bytes

  ExamenVphResponse({
    required this.publicId,
    required this.fechaExamen,
    this.fechaResultado,
    required this.dispositivo,
    this.tipo,
    this.tamano,
    this.nombre,
    this.diagnostico,
    required this.genotipos,
    this.contenido,
  });

  factory ExamenVphResponse.fromJson(Map<String, dynamic> json) {
    return ExamenVphResponse(
      publicId: json['publicId'],
      fechaExamen: json['fechaExamen'],
      fechaResultado: json['fechaResultado'],
      dispositivo: json['dispositivo'],
      tipo: json['tipo'],
      tamano: json['tamano'],
      nombre: json['nombre'],
      diagnostico: json['diagnostico'],
      genotipos: json['genotipos'] is List
      ? List<String>.from(json['genotipos'])
      : [json['genotipos']],
      contenido: json['contenido'] != null ? base64Decode(json['contenido']) : null,
    );
  }
}
