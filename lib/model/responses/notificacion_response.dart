class NotificacionResponse {
  final String publicId;
  final String tipoNotificacion;
  final String titulo;
  final String mensaje;
  final String? accion;
  final String? tipoAccion;
  final String fecha;
  bool leido;

  NotificacionResponse({
    required this.publicId,
    required this.tipoNotificacion,
    required this.titulo,
    required this.mensaje,
    this.accion,
    this.tipoAccion,
    required this.fecha,
    required this.leido,
  });

  factory NotificacionResponse.fromJson(Map<String, dynamic> json) {
    return NotificacionResponse(
      publicId: json['publicId'] ?? '',
      tipoNotificacion: json['tipoNotificacion'] ?? '',
      titulo: json['titulo'] ?? '',
      mensaje: json['mensaje'] ?? '',
      tipoAccion: json['tipoAccion'],
      accion: json['accion'],
      fecha: json['fechaEnvio'] ?? '',
      leido: json['leido'] ?? false,
    );
  }
}
