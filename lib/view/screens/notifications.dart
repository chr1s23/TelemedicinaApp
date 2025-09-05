//view/screens/notifications.dart
import 'package:chatbot/model/responses/notificacion_response.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/firebase_messaging_handler.dart';
import 'package:chatbot/service/notification_service.dart';
//import 'package:chatbot/view/screens/result.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/service/notification_state.dart';
import 'package:chatbot/utils/notificacion_flags.dart';

/*
*********************************************************
Componente Principal de la vista. StatefulWidget es utilizado
para manejar el estado de las notificaciones y la interacción
con el usuario.(El contenido cambia dinámicamente)

**********************************************************
*/
class Notifications extends StatefulWidget {
  final VoidCallback? onNotificacionesLeidas;
  static final GlobalKey<NotificationsPageState> globalKey =
      GlobalKey<NotificationsPageState>();

  Notifications({this.onNotificacionesLeidas}) : super(key: globalKey);

  @override
  State<Notifications> createState() => NotificationsPageState();
}
/*
**********************************************************
Clase que maneja el estado de la vista de notificaciones
**********************************************************
*/

class NotificationsPageState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  bool _recargarPendiente = false;
  //Controla que pestaña está activa
  late TabController _tabController;
  //Lista las notificaciones obtenidas desde el servicio
  List<NotificacionResponse> _notificaciones = [];
  // Indica si las notificaciones están cargando
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    //debugSecureStorage();
    //Definición de las 3 pestañas.
    _tabController = TabController(length: 3, vsync: this);
    //Trae las notificaciones con el servicio
    if (NotificacionFlags.hayNotificacionNueva) {
      _cargarNotificaciones();
      NotificacionFlags.hayNotificacionNueva = false;
    } else {
      _cargarNotificaciones();
    }
  }

  /*
   ************************************************************************ 
   Método que se llama cuando las dependencias cambian. Aquí se verifica si hay 
   una nueva notificación y se recarga la lista.
   ************************************************************************
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (NotificacionFlags.hayNotificacionNueva) {
      _cargarNotificaciones();
      NotificacionFlags.hayNotificacionNueva = false;
    }
  }

  /** 
   * Libera al controlador de pestañas cuando se cierra la vista
  ***/
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /**
   * Carga las notificaciones desde la memoria y actualiza el estado
   */

  Future<void> _cargarNotificaciones() async {
    if (NotificacionFlags.hayNotificacionNueva) {
      final userId = await secureStorage.read(key: "user_id");
      if (userId != null) {
        final nuevas =
            await NotificationService.cargarNotificacionesxPublicID(userId);
        NotificationState().actualizar(nuevas); // actualiza en memoria
        NotificacionFlags.hayNotificacionNueva = false;
      }
    }

    final resultado = NotificationState().notificaciones;
    setState(() {
      _notificaciones = resultado;
      _isLoading = false;
      _recargarPendiente = false;
    });
  }

  Future<void> recargarDesdeExterior() async {
    await _cargarNotificaciones();
    widget.onNotificacionesLeidas?.call();
    setState(() {}); // para refrescar lista sin cambiar tab
  }

  @override
  Widget build(BuildContext context) {
    // Si hay notificación pendiente, la recargo
    if (NotificacionFlags.hayNotificacionNueva && !_recargarPendiente) {
      _recargarPendiente = true; // evitamos loops infinitos
      NotificacionFlags.hayNotificacionNueva = false;
      _cargarNotificaciones(); // async pero sin esperar
    }

    return Scaffold(
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildNotificationList()),
        ],
      ),
    );
  }

  void debugSecureStorage() async {
    final all = await secureStorage.readAll();
    /*
    print(
        "*************************************************************** Contenido de secureStorage:");
    all.forEach((key, value) => print("🔑 $key => $value"));
    */
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AllowedColors.blue,
      labelColor: AllowedColors.blue,
      unselectedLabelColor: AllowedColors.gray,
      tabs: const [
        Tab(text: "Todas"),
        Tab(text: "Leídas"),
        Tab(text: "No leídas"),
      ],
      onTap: (index) {
        setState(() {});
      },
    );
  }

  /**
   * Filtra y muestra la lista de notificaciones en la respectiva pestaña
   */
  Widget _buildNotificationList() {
    List<NotificacionResponse> filtered;
    switch (_tabController.index) {
      case 1:
        filtered = _notificaciones.where((n) => n.leido).toList();
        break;
      case 2:
        filtered = _notificaciones.where((n) => !n.leido).toList();
        break;
      default:
        filtered = _notificaciones;
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) => _buildNotificationCard(filtered[index]),
    );
  }

  String _formatearFechaInteligente(String fechaIso) {
    try {
      final date = DateTime.parse(fechaIso);
      final ahora = DateTime.now();
      final esHoy = date.year == ahora.year &&
          date.month == ahora.month &&
          date.day == ahora.day;

      if (esHoy) {
        return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else {
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";
      }
    } catch (e) {
      return "";
    }
  }

  Widget _buildNotificationCard(NotificacionResponse notif) {
    return GestureDetector(
      // Detecta el toque en la notificación: Marca como leída si no lo estaba y cambia a la pestaña "Leídas"
      onTap: () async {
        if (!notif.leido) {
          try {
            await NotificationService.marcarNotificacionComoLeida(
                notif.publicId);
            NotificationState().marcarComoLeida(notif.publicId);
            _cargarNotificaciones();
            //_tabController.animateTo(1); //  cambia a "Leídas"
            widget.onNotificacionesLeidas?.call(); // Actualiza al punto rojo
            //showSnackBar(context, "Notificación marcada como leída");
          } catch (e) {
            showSnackBar(context, "Error al marcar como leída");
            print("[X] Error al marcar notificación como leída: $e");
          }
        }
        FirebaseMessagingHandler.manejarClickNotificacion({
          "publicId": notif.publicId,
          "tipoNotificacion": notif.tipoNotificacion,
          "titulo": notif.titulo,
          "mensaje": notif.mensaje,
          "accion": notif.accion,
        });
      },
      // Construye la tarjeta de notificación
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: notif.leido ? Colors.white : Colors.grey[200],
        child: ListTile(
          leading:
              Icon(Icons.notifications, color: AllowedColors.blue, size: 30),
          title: Text(
            notif.titulo,
            style: TextStyle(
              fontWeight: notif.leido ? FontWeight.normal : FontWeight.bold,
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            notif.mensaje,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Text(
            _formatearFechaInteligente(notif.fecha),
            style: TextStyle(fontSize: 10, color: AllowedColors.gray),
          ),
        ),
      ),
    );
  }
}
