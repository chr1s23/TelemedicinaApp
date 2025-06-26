import 'package:chatbot/model/responses/notificacion_response.dart';


class NotificationState {
  static final NotificationState _instance = NotificationState._internal();

  factory NotificationState() => _instance;

  NotificationState._internal();

  List<NotificacionResponse> _notificaciones = [];

  List<NotificacionResponse> get notificaciones => _notificaciones;

  void actualizar(List<NotificacionResponse> nuevas) {
    _notificaciones = nuevas;
  }

  void marcarComoLeida(String publicId) {
    _notificaciones = _notificaciones.map((n) {
      if (n.publicId == publicId) {
        return n.copyWith(leido: true);
      }
      return n;
    }).toList();
  }

  bool get hayNoLeidas => _notificaciones.any((n) => !n.leido);
}
