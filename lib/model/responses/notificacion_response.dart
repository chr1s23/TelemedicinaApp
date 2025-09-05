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
  NotificacionResponse copyWith({
    String? publicId,
    String? tipoNotificacion,
    String? titulo,
    String? mensaje,
    String? accion,
    String? tipoAccion,
    String? fecha,
    bool? leido,
  }) {
    return NotificacionResponse(
      publicId: publicId ?? this.publicId,
      tipoNotificacion: tipoNotificacion ?? this.tipoNotificacion,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      accion: accion ?? this.accion,
      tipoAccion: tipoAccion ?? this.tipoAccion,
      fecha: fecha ?? this.fecha,
      leido: leido ?? this.leido,
    );
  }
}
  
