import 'package:chatbot/view/screens/about_us.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.helpButton = false, this.profileButton = true});

  final bool helpButton;
  final bool profileButton;

  @override
  State<StatefulWidget> createState() {
    return CustomAppBarState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(62);
}

class CustomAppBarState extends State<CustomAppBar> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _initVideoPlayer() async {
    final video = VideoPlayerController.asset('assets/videos/sample.mp4');
    await video.initialize();

    final chewie = ChewieController(
      videoPlayerController: video,
      autoPlay: false,
      aspectRatio: video.value.aspectRatio, // Relación real del video
      allowFullScreen: true,
      fullScreenByDefault: false,
      showControlsOnInitialize: true,
      deviceOrientationsOnEnterFullScreen: null, // Permitir comportamiento automático
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    setState(() {
      _videoController = video;
      _chewieController = chewie;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: widget.helpButton
          ? SizedBox(
              width: 90,
              height: 45,
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: IconButton(
                  padding: const EdgeInsets.all(1),
                  style: IconButton.styleFrom(
                    backgroundColor: AllowedColors.red,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    _showHelpDialog(context);
                  },
                  icon: const Icon(Icons.help_outline, color: AllowedColors.white),
                  iconSize: 30,
                ),
              ),
            )
          : null,
      title: const Text(
        "SISA",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AllowedColors.red,
        ),
      ),
      centerTitle: true,
      actions: widget.profileButton
          ? [
              IconButton(
                icon: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                  radius: 15,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ]
          : null,
    );
  }

  void _showHelpDialog(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.9;
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón de cerrar
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: AllowedColors.black, size: 24),
                      onPressed: () {
                        _videoController?.pause();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  // Contenedor del video
                  if (_videoController != null && _videoController!.value.isInitialized)
                    Container(
                      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Chewie(controller: _chewieController!),
                        ),
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),

                  // Botones
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        CustomButton(
                          color: AllowedColors.red,
                          onPressed: () {
                            _videoController?.pause();
                            Navigator.pop(context);
                          },
                          label: "Entendido",
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          color: AllowedColors.blue,
                          onPressed: () {
                            _videoController?.pause();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AboutUs()),
                            );
                          },
                          label: "Acerca de",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
