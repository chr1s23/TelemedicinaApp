import 'package:chatbot/view/screens/about_us.dart';
import 'package:chatbot/view/screens/chat.dart';
import 'package:chatbot/view/screens/notifications.dart';
import 'package:chatbot/view/screens/personal_data_form.dart';
import 'package:chatbot/view/screens/resources.dart';
import 'package:chatbot/view/screens/wip.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _AutoSamplingPageState();
}

class _AutoSamplingPageState extends State<Dashboard> {
  late VideoPlayerController _videoController;
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
  }

  @override
  void dispose() {
    _videoController.dispose();
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
      bottomNavigationBar: _buildBottomNavigationBar((index) => _currentIndex = index, () => _currentIndex),
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
            backgroundColor: const Color.fromRGBO(165, 16, 08, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            _showHelpDialog();
          },
          child: Text("H", style: TextStyle(fontSize: 12, color: Colors.white)),
        ),
      ),
      title: Text(
        "HELPY",
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(165, 16, 8, 1)),
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
            final helpVideoController =
                VideoPlayerController.asset('assets/videos/sample.mp4');

            helpVideoController.initialize().then((_) {
              setState(() {});
              helpVideoController.play(); // Reproduce automáticamente
            });

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
                          color: Colors.black, size: 24),
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
                        ? VideoPlayer(helpVideoController)
                        : const Center(child: CircularProgressIndicator()),
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
                            backgroundColor:
                                const Color.fromRGBO(165, 16, 08, 1),
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
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(0, 40, 86, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUs()));
                          },
                          child: Text(
                            "Acerca de",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
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
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
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
          _buildStartProcessButton(),
          const SizedBox(height: 15),
          Text(
              "Este video explica el proceso de automuestreo. Sigue los pasos descritos para completar el procedimiento correctamente.",
              style: TextStyle(
                  fontSize: 12, color: Color.fromRGBO(111, 111, 111, 1))),
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

  Widget _buildStartProcessButton() {
    return SizedBox(
      width: 300,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(0, 40, 86, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          // Acción de iniciar proceso, agregar desde aqui los criterios de inclusion
          //para el chatbot cuando este listo
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Chat()));
        },
        child: Text(
          "Iniciar proceso",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(void Function(int) setIndex, int Function() currentIndex) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          setIndex(index);
        });
      },
      indicatorShape: CircleBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide, // Ocultar labels
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
  //       backgroundColor: Color.fromRGBO(0, 40, 86, 1),
  //       onPressed: () {
  //         // Acción del asistente virtual
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => Chat()));
  //       },
  //       child: const Icon(Icons.smart_toy, size: 28, color: Colors.white),
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
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
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
                  backgroundColor: Color.fromRGBO(165, 16, 08, 1),
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
                    color: Colors.white,
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
      leading: Icon(icon, color: Color.fromRGBO(0, 40, 86, 1)),
      title: Text(
        label,
        style: TextStyle(fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}
