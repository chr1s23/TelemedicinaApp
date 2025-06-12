import 'package:chatbot/model/storage/storage.dart';
import 'package:chatbot/utils/connectivity_listener.dart';
import 'package:chatbot/view/screens/chat.dart';
import 'package:chatbot/view/screens/form_chat.dart';
import 'package:chatbot/view/screens/maps_menu_screen.dart';
//import 'package:chatbot/view/screens/notifications.dart';
import 'package:chatbot/view/screens/resources.dart';
import 'package:chatbot/view/screens/scanner.dart';
import 'package:chatbot/view/screens/wip.dart';
import 'package:chatbot/view/widgets/custom_app_bar.dart';
import 'package:chatbot/view/widgets/custom_drawer.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, this.hasInternet = true});

  final bool hasInternet;

  @override
  State<Dashboard> createState() => _AutoSamplingPageState();
}

class _AutoSamplingPageState extends State<Dashboard> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  int _currentIndex = 0;
  bool deviceRegistered = false;
  bool videoComplete = false;

  @override
  void initState() {
    _initializePlayer();
    super.initState();
  }

  Future<void> _initializePlayer() async {
    String? dispositivo = await secureStorage.read(key: "user_device");
    String? autoPlay = await secureStorage.read(key: "auto_play");

    var (video, chewie) =
        await initializeVideoPlayer('assets/videos/automuestreo.mp4');

    // Listener para saber si terminó el video
    video.addListener(() {
      if (video.value.position >= video.value.duration && !videoComplete) {
        setState(() {
          videoComplete = true;
        });
      }
    });

    setState(() {
      if (dispositivo != null) {
        deviceRegistered = true;
      }
      if (autoPlay == "off") {
        videoComplete = true;
      }
      _videoController = video;
      _chewieController = chewie;
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: AllowedColors.blue,
          shape: const CircleBorder(),
          elevation: 0,
          heroTag: "chatbot",
          child: SvgPicture.asset("assets/icons/chatbot.svg",
              height: 50, width: 50),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConnectivityListener(
                        child: Chat(),
                      ))),
        ),
      ),
      appBar: const CustomAppBar(
        helpButton: true,
      ),
      endDrawer: widget.hasInternet
          ? const CustomDrawer()
          : null, // Drawer que se desliza desde la derecha
      body: <Widget?>[
        _buildBody(),
        Resources(),
        const MapsMenuScreen(), // Pantalla de mapas
        WIPScreen(),
        //Notifications(),
      ][_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(
          (index) => _currentIndex = index, () => _currentIndex),
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
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AllowedColors.black),
          ),
          const SizedBox(height: 15),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                buildVideoPlayer(_videoController, _chewieController),
                const SizedBox(height: 20),
                CustomButton(
                    color: deviceRegistered
                        ? AllowedColors.blue
                        : AllowedColors.gray,
                    label: "Iniciar proceso de Automuestreo",
                    onPressed: deviceRegistered
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormChat()));
                          }
                        : null,
                    size: 340),
                const SizedBox(height: 20),
                CustomButton(
                    color: !videoComplete
                        ? AllowedColors.gray
                        : deviceRegistered
                            ? AllowedColors.gray
                            : AllowedColors.blue,
                    label: "Registrar dispositivo de Automuestreo",
                    onPressed: !videoComplete
                        ? null
                        : deviceRegistered
                            ? null
                            : () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Scanner(deviceRegister: true)));
                              },
                    size: 340),
                const SizedBox(height: 15),
                Text(
                    "Este video explica el proceso de automuestreo. Sigue los pasos descritos para completar el procedimiento correctamente.",
                    style: TextStyle(fontSize: 12, color: AllowedColors.gray)),
                const SizedBox(
                  height: 150,
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(
      void Function(int) setIndex, int Function() currentIndex) {
    const homeIndex = 0;
    const resourcesIndex = 1;
    const mapIndex = 2;
    const notificationsIndex = 3;

    changePage(int index) => setState(() {
          setIndex(index);
        });

    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: AllowedColors.blue,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
                currentIndex() == homeIndex ? Icons.home : Icons.home_outlined),
            color: AllowedColors.white,
            onPressed: () {
              currentIndex() != homeIndex ? changePage(homeIndex) : null;
            },
          ),
          IconButton(
            icon: Icon(currentIndex() == resourcesIndex
                ? Icons.folder
                : Icons.folder_outlined),
            color: AllowedColors.white,
            onPressed: () {
              currentIndex() != resourcesIndex
                  ? changePage(resourcesIndex)
                  : null;
            },
          ),
          SizedBox(width: 50),
          IconButton(
            icon: Icon(
                currentIndex() == mapIndex ? Icons.map : Icons.map_outlined),
            color: AllowedColors.white,
            onPressed: () {
              currentIndex() != mapIndex ? changePage(mapIndex) : null;
            },
          ),
          IconButton(
            icon: Badge(
                child: Icon(currentIndex() == notificationsIndex
                    ? Icons.notifications
                    : Icons.notifications_outlined)),
            color: AllowedColors.white,
            onPressed: () {
              currentIndex() != notificationsIndex
                  ? changePage(notificationsIndex)
                  : null;
            },
          ),
        ],
      ),
    );
  }
}
