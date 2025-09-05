class UbicacionResponse {
  final String publicId;
  final String nombre;
  final String direccion;
  final String telefono;
  final String horario;
  final String sitioWeb;
  final double latitud;
  final double longitud;
  final String establecimiento;

  UbicacionResponse({
    required this.publicId,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.horario,
    required this.sitioWeb,
    required this.latitud,
    required this.longitud,
    required this.establecimiento,
  });

  factory UbicacionResponse.fromJson(Map<String, dynamic> json) {
    return UbicacionResponse(
      publicId: json['publicId'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      horario: json['horario'],
      sitioWeb: json['sitioWeb'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      establecimiento: json['establecimiento'],
    );
  }
}
