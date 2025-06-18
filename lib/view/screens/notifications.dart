import 'package:chatbot/model/responses/notificacion_response.dart';
import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/service/notification_service.dart';
import 'package:chatbot/view/screens/result.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /*
  final List<Map<String, dynamic>> _notifications = [
    {
      "icon": Icons.description,
      "description": "El resultado de su prueba se encuentra listo!",
      "attachments": [
        {
          "type": "pdf",
          "name": "Resultado.pdf",
          "path": "assets/docs/resultado.pdf"
        },
      ],
      "date": "15m",
      "isRead": false,
    },
    {
      "icon": Icons.notifications,
      "description": "Termina de configurar tu perfil.",
      "attachments": [],
      "date": "1m",
      "isRead": false,
    },
    {
      "icon": Icons.link,
      "description": "Consulta este enlace para más información.",
      "attachments": [
        {"type": "link", "name": "https://example.com"},
      ],
      "date": "15/02/2023",
      "isRead": true,
    },
  ];
*/
  List<NotificacionResponse> _notificaciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugSecureStorage();
    print("------Init Notifications");
    _tabController = TabController(length: 3, vsync: this);
    _cargarNotificaciones();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildNotificationList()),
        ],
      ),
    );
  }

  Future<void> _cargarNotificaciones() async {
     print("▶ Ejecutando _cargarNotificaciones");
    final cuentaUsuarioId = await secureStorage.read(key: "user_id");
    print("**** cuentaUsuarioPublicId = $cuentaUsuarioId");
    if (cuentaUsuarioId != null) {
      try {
        final resultado =
            await NotificationService.fetchNotifications(cuentaUsuarioId);
        setState(() {
          _notificaciones = resultado;
          _isLoading = false;
        });
      } catch (e) {
        print("Error al mostrar notificaciones: $e");
      }
    }else {
      print("No se encontró el ID del paciente");
      setState(() {
        _isLoading = false;
      });
    }
  }

   void debugSecureStorage() async {
  final all = await secureStorage.readAll();
  print("*************************************************************** Contenido de secureStorage:");
  all.forEach((key, value) => print("🔑 $key => $value"));
}
  
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AllowedColors.blue,
      labelColor: AllowedColors.blue,
      unselectedLabelColor: AllowedColors.gray,
      tabs: [
        Tab(text: "Todas"),
        Tab(text: "Leídas"),
        Tab(text: "No leídas"),
      ],
      onTap: (index) {
        setState(() {});
      },
    );
  }

  Widget _buildNotificationList() {
    List<NotificacionResponse> filtered;
    switch (_tabController.index) {
      case 1: // Leídas
        filtered = _notificaciones.where((n) => n.leido).toList();
        break;
      case 2: // No leídas
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
      onTap: () {
        if (!notif.leido) {
          setState(() {
            notif.leido = true;
          });
          // Aquí puedes hacer una petición PUT para marcarla como leída en el backend si deseas
        }
      },
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
            style: TextStyle(fontSize: 12),
          ),
          trailing: Text(
            notif.fecha,
            style: TextStyle(fontSize: 10, color: AllowedColors.gray),
          ),
        ),
      ),
    );
  }

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
  }
}
