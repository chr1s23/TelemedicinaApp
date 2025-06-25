import 'package:chatbot/view/screens/resource_detail.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Resources extends StatefulWidget {
  const Resources({super.key});

  @override
  State<Resources> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<Resources> {
  final List<Map<String, dynamic>> _videos = [
    {
      "title": "Detección Cáncer Cervical",
      "description":
          "Aprende sobre el cáncer cervical y sus formas de detección",
      "videoPath": "assets/videos/automuestreo.mp4",
      "rating": 4.8,
      "liked": false,
    },
    {
      "title": "Automuestreo",
      "description":
          "Aprende el proceso correcto para realizar un automuestreo de Virus de Papiloma Humano.",
      "videoPath": "assets/videos/short.mp4",
      "rating": 4.3,
      "liked": false,
    },
  ];

  void _toggleLike(int index) {
    setState(() {
      _videos[index]["liked"] = !_videos[index]["liked"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return _buildVideoCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Recursos",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AllowedColors.black,
          ),
        ),
        TextButton(
          onPressed: () {
            // Acción de ver todos los videos
          },
          child: Text(
            "Ver todos",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AllowedColors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(int index) {
    final video = _videos[index];
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVideoThumbnail(video["videoPath"], index),
            const SizedBox(height: 10),
            Text(
              video["title"],
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AllowedColors.black,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              video["description"],
              style: TextStyle(
                  fontSize: 12, color: AllowedColors.gray),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      video["rating"].toString(),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    video["liked"] ? Icons.favorite : Icons.favorite_border,
                    color: video["liked"]
                        ? Colors.red
                        : AllowedColors.gray,
                    size: 24,
                  ),
                  onPressed: () => _toggleLike(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail(String videoPath, int index) {
    VideoPlayerController videoController =
        VideoPlayerController.asset(videoPath);
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: FutureBuilder(
            future: videoController.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return VideoPlayer(videoController); // Muestra la miniatura del video
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
               context,
               MaterialPageRoute(
                 builder: (context) =>
                     ResourceDetail(videos: _videos, initialIndex: index),
               ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AllowedColors.black,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(15),
              child:
                  const Icon(Icons.play_arrow, color: AllowedColors.white, size: 50),
            ),
          ),
        ),
      ],
    );
  }
}
