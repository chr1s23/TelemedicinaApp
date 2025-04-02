import 'package:chatbot/view/screens/about_us.dart';
import 'package:chatbot/view/widgets/custom_button.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.helpButton = false});

  final bool helpButton;

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
    _initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _initVideoPlayer() async {
    var (video, chewie) = await initializeVideoPlayer(
      'assets/videos/sample.mp4',
      autoPlay: true,
    );

    _videoController = video;
    _chewieController = chewie;

    setState(() {});
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
                    shape: CircleBorder(),
                  ),
                  onPressed: () {
                    _showHelpDialog(context);
                  },
                  icon: const Icon(Icons.help_outline,
                      color: AllowedColors.white),
                  iconSize: 30,
                ),
              ),
            )
          : null,
      title: Text(
        "SISA",
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
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

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Botón de cerrar (X)
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close,
                        color: AllowedColors.black, size: 24),
                    onPressed: () {
                      _videoController?.pause();
                      //helpVideoController.dispose();
                      Navigator.pop(context);
                    },
                  ),
                ),

                // Video
                buildVideoPlayer(_videoController, _chewieController),
                const SizedBox(height: 15),
                Column(children: [
                  CustomButton(
                      color: AllowedColors.red,
                      onPressed: () {
                        _videoController?.pause();
                        Navigator.pop(context);
                      },
                      label: "Entendido"),
                  const SizedBox(height: 20),
                  CustomButton(
                      color: AllowedColors.blue,
                      onPressed: () {
                        _videoController?.pause();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AboutUs()));
                      },
                      label: "Acerca de"),
                  const SizedBox(height: 15)
                ])
              ]),
            ));
      },
    );
  }
}
