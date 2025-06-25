import 'package:chatbot/model/responses/notificacion_response.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/notification_service.dart';
//import 'package:chatbot/view/screens/result.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

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

class NotificationsPageState extends State<Notifications> with SingleTickerProviderStateMixin {

  //Controla que pestaña está activa
  late TabController _tabController;
  //Lista las notificaciones obtenidas desde el servicio
  List<NotificacionResponse> _notificaciones = [];
  // Indica si las notificaciones están cargando
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugSecureStorage();
    print("📩 ------Init Notifications");
    //Definición de las 3 pestañas.
    _tabController = TabController(length: 3, vsync: this);
    //Trae las notificaciones con el servicio
    _cargarNotificaciones();
  }
  /** 
   * Libera al controlador de pestañas cuando se cierra la vista
  ***/
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarNotificaciones() async {
    final cuentaUsuarioId = await secureStorage.read(key: "user_id");
    if (cuentaUsuarioId != null) {
      try {
        final resultado =
            await NotificationService.fetchNotifications(cuentaUsuarioId);

        // DEBUG DE LAS NOTIFICACIONES DE LA USUARIA
        for (var n in resultado) {
          print("************🧾 ${n.titulo} - leído: ${n.leido}");
        }
        // Actualiza el estado con las notificaciones obtenidas
        setState(() {
          _notificaciones = resultado;
          _isLoading = false;
        });
      } catch (e) {
        print("Error al mostrar notificaciones: $e");
      }
    } else {
       
      // Apartado Vacío si es que la usuaria no tiene notificaciones
  
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> recargarDesdeExterior() async {
    print("♻️ Recargando notificaciones desde push...");
  await _cargarNotificaciones();
  widget.onNotificacionesLeidas?.call();
  setState(() {}); // para refrescar lista sin cambiar tab
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildNotificationList()), //El contenido cambia según la pestaña _buildNotificationList
        ],
      ),
    );
  }

  void debugSecureStorage() async {
    final all = await secureStorage.readAll();
    print(
        "*************************************************************** Contenido de secureStorage:");
    all.forEach((key, value) => print("🔑 $key => $value"));
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

  Widget _buildNotificationCard(NotificacionResponse notif) {
    return GestureDetector(
      // Detecta el toque en la notificación: Marca como leída si no lo estaba y cambia a la pestaña "Leídas"
      onTap: () async {
        if (!notif.leido) {
          try {
            await NotificationService.marcarNotificacionComoLeida(
                notif.publicId);
            await _cargarNotificaciones(); // Recarga de notificaciones
            _tabController.animateTo(1); //  cambia a "Leídas"
            widget.onNotificacionesLeidas?.call(); // Actualiza al punto rojo
            showSnackBar(context, "Notificación marcada como leída");
          } catch (e) {
            showSnackBar(context, "Error al marcar como leída");
            print("[X] Error al marcar notificación como leída: $e");
          }
        }
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
            notif.fecha,
            style: TextStyle(fontSize: 10, color: AllowedColors.gray),
          ),
        ),
      ),
    );
  }

  /*

  Widget _buildAttachments(List<dynamic> attachments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: attachments.map((attachment) {
        return Row(
          children: [
            Icon(
              attachment["type"] == "pdf" ? Icons.picture_as_pdf : Icons.link,
              color: AllowedColors.gray,
              size: 16,
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () {
                attachment["type"] == "pdf"
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                //Result(pdfName: attachment["path"])))
                                Result(
                                    pdfName:
                                        "violencia_genero_autocuidado.pdf")))
                    : () => {};
              },
              child: Text(
                attachment["name"],
                style: TextStyle(fontSize: 11, color: AllowedColors.blue),
              ),
            )
          ],
        );
      }).toList(),
    );
  }*/
}
