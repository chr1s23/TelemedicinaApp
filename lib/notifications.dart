import 'package:chatbot/chat.dart';
import 'package:chatbot/dashboard.dart';
import 'package:chatbot/resources.dart';
import 'package:chatbot/result.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildNotificationList()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text("HELPY",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
            radius: 18,
          ),
          onPressed: () {
            // Acción del perfil
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Color.fromRGBO(0, 40, 86, 1),
      labelColor: Color.fromRGBO(0, 40, 86, 1),
      unselectedLabelColor: Color.fromRGBO(111, 111, 111, 1),
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
    List<Map<String, dynamic>> filteredNotifications;
    switch (_tabController.index) {
      case 1: // Leídas
        filteredNotifications =
            _notifications.where((n) => n["isRead"]).toList();
        break;
      case 2: // No leídas
        filteredNotifications =
            _notifications.where((n) => !n["isRead"]).toList();
        break;
      default: // Todas
        filteredNotifications = _notifications;
    }

    return ListView.builder(
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(filteredNotifications[index]);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(notification["icon"],
            color: Color.fromRGBO(0, 40, 86, 1), size: 30),
        title: Text(
          notification["description"],
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                notification["isRead"] ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification["attachments"].isNotEmpty)
              _buildAttachments(notification["attachments"]),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              notification["date"],
              style: TextStyle(
                  fontSize: 10, color: Color.fromRGBO(111, 111, 111, 1)),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  size: 20, color: Color.fromRGBO(111, 111, 111, 1)),
              onSelected: (value) {
                // Acción según opción seleccionada
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: "markUnread", child: Text("Marcar como no leído")),
                const PopupMenuItem(value: "delete", child: Text("Eliminar")),
              ],
            ),
          ],
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
              color: Color.fromRGBO(111, 111, 111, 1),
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
                                Result(pdfPath: attachment["path"])))
                    : () => {};
              },
              child: Text(
                attachment["name"],
                style: TextStyle(
                    fontSize: 11, color: Color.fromRGBO(0, 40, 86, 1)),
              ),
            )
          ],
        );
      }).toList(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home, false,
                MaterialPageRoute(builder: (context) => Dashboard())),
            _buildNavItem(Icons.folder, false,
                MaterialPageRoute(builder: (context) => Resources())),
            _buildFloatingButton(),
            _buildNavItem(Icons.map, false, null),
            _buildNavItem(Icons.notifications, false, null),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool marked, MaterialPageRoute? nav) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () {
              if (nav != null) {
                Navigator.push(context, nav);
              }
            },
            icon: Icon(icon,
                color: marked
                    ? Color.fromRGBO(0, 40, 86, 1)
                    : Color.fromRGBO(111, 111, 111, 1),
                size: 28))
      ],
    );
  }

  Widget _buildFloatingButton() {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 40, 86, 1),
        onPressed: () {
          // Acción del asistente virtual
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Chat()));
        },
        child: const Icon(Icons.smart_toy, size: 28, color: Colors.white),
      ),
    );
  }
}
