import 'package:chatbot/view/screens/about_us.dart';
import 'package:chatbot/view/screens/chat.dart';
import 'package:chatbot/view/screens/notifications.dart';
import 'package:chatbot/view/screens/personal_data_form.dart';
import 'package:chatbot/view/screens/resources.dart';
import 'package:chatbot/view/screens/scanner.dart';
import 'package:chatbot/view/screens/wip.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _AutoSamplingPageState();
}

class _AutoSamplingPageState extends State<Dashboard> {
  late VideoPlayerController _videoController;
  late VideoPlayerController helpVideoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('assets/videos/automuestreo.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
    _videoController.play();
    _videoController.setLooping(false);
    helpVideoController = VideoPlayerController.asset('assets/videos/sample.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    helpVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      endDrawer:
          _buildProfileDrawer(), // Drawer que se desliza desde la derecha
      body: <Widget?>[
        SingleChildScrollView(child: _buildBody()),
        Resources(),
        Chat(),
        WIPScreen(),
        Notifications(),
      ][_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(
          (index) => _currentIndex = index, () => _currentIndex),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: SizedBox(
        width: 100,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AllowedColors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            _showHelpDialog();
          },
          child: Text("Ayuda",
              style: TextStyle(fontSize: 12, color: AllowedColors.white)),
        ),
      ),
      title: Text(
        "SISA",
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AllowedColors.red),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundImage:
                AssetImage('assets/images/avatar.png'), // Imagen del avatar
            radius: 15,
          ),
          onPressed: () {
            // Acción del perfil
            Scaffold.of(context)
                .openEndDrawer(); // Abre el Drawer desde la derecha
          },
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Evita que el usuario cierre el diálogo tocando fuera
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón de cerrar (X)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close,
                          color: AllowedColors.black, size: 24),
                      onPressed: () {
                        helpVideoController.pause();
                        helpVideoController.dispose();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  // Video
                  AspectRatio(
                    aspectRatio: helpVideoController.value.isInitialized
                        ? helpVideoController.value.aspectRatio
                        : 16 / 9,
                    child: helpVideoController.value.isInitialized
                        ? InkWell(
                            child: VideoPlayer(helpVideoController),
                            onTap: () {
                              setState(() {
                                helpVideoController.value.isPlaying
                                    ? helpVideoController.pause()
                                    : helpVideoController.play();
                              });
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),

                  const SizedBox(height: 15),

                  // Botones en la parte inferior
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AllowedColors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            helpVideoController.pause();
                            helpVideoController.dispose();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Entendido",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AllowedColors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AllowedColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUs()));
                          },
                          child: Text(
                            "Acerca de",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AllowedColors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Automuestreo",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AllowedColors.black),
          ),
          const SizedBox(height: 15),
          _buildVideoPlayer(),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _videoController.value.isPlaying
                    ? _videoController.pause()
                    : _videoController.play();
              });
            },
            child: Icon(
              _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
              color: Color.fromRGBO(0, 40, 86, 1),
              label: "Iniciar proceso",
              onPressed: () {
                // funciona para ir a la ventana del chat, automaticamente se conecta mediante sockets
                // por defecto cuando se inicia enviar un mensaje al chatbot para iniciar el proceso, por ejmplo "comenzar proceso"
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Chat()));
              }),
          const SizedBox(height: 20),
          CustomButton(
              color: Color.fromRGBO(0, 40, 86, 1),
              label: "Registrar Dispositivo",
              onPressed: () {
                // Acción de registrar el dispositivo, llevar a la pagina de escanear el dispositivo y guardar la ifnormacion en el servidor
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Scanner()));
              }),
          const SizedBox(height: 15),
          Text(
              "Este video explica el proceso de automuestreo. Sigue los pasos descritos para completar el procedimiento correctamente.",
              style: TextStyle(fontSize: 12, color: AllowedColors.gray)),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: _videoController.value.isInitialized
          ? _videoController.value.aspectRatio
          : 16 / 9,
      child: _videoController.value.isInitialized
          ? InkWell(
              child: VideoPlayer(_videoController),
              onTap: () {
                setState(() {
                  _videoController.value.isPlaying
                      ? _videoController.pause()
                      : _videoController.play();
                });
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBottomNavigationBar(
      void Function(int) setIndex, int Function() currentIndex) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          setIndex(index);
        });
      },
      indicatorShape: CircleBorder(),
      labelBehavior:
          NavigationDestinationLabelBehavior.alwaysHide, // Ocultar labels
      selectedIndex: currentIndex(),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.folder),
          label: 'Recursos',
        ),
        NavigationDestination(
          icon: Icon(Icons.smart_toy),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.map),
          label: 'Mapa',
        ),
        NavigationDestination(
          icon: Badge(child: Icon(Icons.notifications)),
          label: 'Notificaciones',
        ),
      ],
    );
  }

  // Widget _buildFloatingButton() {
  //   return Transform.translate(
  //     offset: const Offset(0, -10),
  //     child: FloatingActionButton(
  //       backgroundColor: AllowedColors.blue,
  //       onPressed: () {
  //         // Acción del asistente virtual
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => Chat()));
  //       },
  //       child: const Icon(Icons.smart_toy, size: 28, color: AllowedColors.white),
  //     ),
  //   );
  // }

  Widget _buildProfileDrawer() {
    return Drawer(
      width: 280, // Ajusta el tamaño del drawer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40), // Espaciado

          // Avatar del Usuario
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          const SizedBox(height: 10),

          // Nombre del Usuario
          Text(
            "Juan Pérez",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AllowedColors.black),
          ),
          const SizedBox(height: 30),

          // Botones de Opciones
          _buildDrawerButton(Icons.person, "Perfil", () {
            Navigator.pop(context); // Cierra el Drawer
            // Navegar a la pantalla de perfil
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PersonalDataForm()));
          }),
          _buildDrawerButton(Icons.info, "Acerca de", () {
            Navigator.pop(context); // Cierra el Drawer
            // Navegar a Acerca de
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AboutUs()));
          }),

          const Spacer(), // Empuja el botón "Cerrar sesión" hacia abajo

          // Botón Cerrar Sesión
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AllowedColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Cierra el Drawer
                  // Agregar lógica de cierre de sesión
                },
                child: Text(
                  "Cerrar sesión",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AllowedColors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerButton(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AllowedColors.blue),
      title: Text(
        label,
        style: TextStyle(fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}
