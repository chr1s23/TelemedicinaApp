import 'package:flutter/material.dart';
import 'package:chatbot/view/screens/blog_automuestreo.dart';
import 'package:chatbot/view/screens/blog_vph.dart';
import 'package:chatbot/view/screens/blog_cancer_cuello_uterino.dart';
import 'package:chatbot/view/screens/blog_embarazo_seguro.dart';
import 'package:chatbot/view/screens/blog_higiene_intima.dart';
import 'package:chatbot/view/screens/blog_violencia_genero.dart';
import 'package:chatbot/view/screens/blog_its.dart';
import 'package:chatbot/view/screens/blog_infertilidad.dart';
import 'package:chatbot/view/screens/blog_prevencion_embarazo.dart';
import 'package:chatbot/view/screens/blog_salud_sexual.dart';
import 'package:chatbot/view/screens/blog_vih.dart';
import 'package:video_player/video_player.dart';
import 'package:chatbot/view/screens/resource_detail.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot/service/resource_service.dart';
import 'dart:convert';
import 'package:chewie/chewie.dart';

class Resources extends StatefulWidget {
  const Resources({super.key});

  @override
  State<Resources> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<Resources> {
  final ResourceService _resourceService = ResourceService();
  List<VideoPlayerController?> _videoControllers = [];
  List<ChewieController?> _chewieControllers = [];
  int? _currentPlayingIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    for (var video in _videos) {
      final videoController = VideoPlayerController.asset(video["videoPath"]);
      await videoController.initialize();
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
        looping: false,
        showControls: true,
      );

      _videoControllers.add(videoController);
      _chewieControllers.add(chewieController);
    }

    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    for (var chewie in _chewieControllers) {
      chewie?.dispose();
    }
    super.dispose();
  }

  final List<Map<String, dynamic>> _videos = [
    {
      "title": "Automuestreo",
      "description":
          "Aprende el proceso correcto para realizar un automuestreo de Virus de Papiloma Humano",
      "videoPath": "assets/videos/automuestreo.mp4",
      "codigo": "video_automuestreo",
    },
    {
      "title": "VPH y cáncer de cuello cervical",
      "description": "Aprende sobre el VPH y el cáncer de cuello cervical",
      "videoPath": "assets/videos/ccu.mp4",
      "codigo": "video_ccu",
    },
    {
      "title": "Autocuidado de la higiene íntima",
      "description": "Aprende cómo cuidar tu zona íntima de la manera correcta",
      "videoPath": "assets/videos/higiene_intima.mp4",
      "codigo": "video_higiene_intima",
    },
    {
      "title": "Violencia de género",
      "description": "Aprende a detectar la violencia de género",
      "videoPath": "assets/videos/violencia.mp4",
      "codigo": "video_violencia",
    },
    {
      "title": "Uso de preservativos",
      "description": "Aprende sobre los tipos de preservativos y cómo se usan",
      "videoPath": "assets/videos/preservativos.mp4",
      "codigo": "video_preservativos",
    },
  ];

  void _toggleLike(int index) {
    setState(() {
      _videos[index]["liked"] = !_videos[index]["liked"];
    });
  }

  // Contador de vistas
  Future<void> _incrementarVistas(String codigo) async {
    await _resourceService.incrementarVista(codigo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                _buildVideos(),
                const SizedBox(height: 10),
                _buildBlogSection(),
              ],
            ),
          ),
        ),
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
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildVideos() {
    return Container(
      height: 360, // altura de la tarjeta de los videos
      child: PageView.builder(
        itemCount: _videos.length,
        onPageChanged: (index) {
          setState(() {});
        },
        itemBuilder: (context, index) {
          return _buildVideoCard(index);
        },
      ),
    );
  }

  Widget _buildVideoCard(int index) {
  if (_videoControllers.length < _videos.length ||
      _chewieControllers.length < _videos.length) {
    return const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  final video = _videos[index];
  return Card(
    elevation: 3,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVideoThumbnail(video["videoPath"], index),
          const SizedBox(height: 8),
          Text(
            video["title"],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            video["description"],
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildVideoThumbnail(String videoPath, int index) {
    final videoController = _videoControllers[index];
    final chewieController = _chewieControllers[index];

    if (videoController != null && videoController.value.isInitialized) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Chewie(controller: chewieController!),
            ),
          ),
          if (!videoController.value.isPlaying)
            Positioned(
              child: GestureDetector(
                onTap: () {
                  for (int i = 0; i < _videoControllers.length; i++) {
                    if (i != index) {
                      _videoControllers[i]?.pause();
                    }
                  }

                  setState(() {
                    videoController.play();
                    _currentPlayingIndex = index;
                  });

                  _incrementarVistas(_videos[index]["codigo"]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.play_arrow,
                      color: Colors.white, size: 30),
                ),
              ),
            ),
        ],
      );
    } else {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Widget _buildBlogSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: 11,
          itemBuilder: (context, index) {
            return _buildBlogCard(index);
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBlogCard(int index) {
    List<Map<String, String>> blogList = [
      {
        "title": "Automuestreo",
        "description":
            "Aprende más sobre el automuestreo, sus beneficios, y cómo se compara con otros métodos",
        "imagePath": "assets/images/Automuestreo.png",
        "page": "BlogAutomuestreoPage",
        "codigo": "blog_automuestreo"
      },
      {
        "title": "VPH y cáncer de cuello cervical",
        "description":
            "Lee sobre el VPH y cómo prevenir el cáncer de cuello cervical",
        "imagePath": "assets/images/VPH.png",
        "page": "BlogVphPage",
        "codigo": "blog_vph"
      },
      {
        "title": "Cáncer de cuello uterino",
        "description":
            "Conoce las causas, prevención y tratamiento del cáncer de cuello uterino",
        "imagePath": "assets/images/ccu.png",
        "page": "BlogCancerCuelloUterinoPage",
        "codigo": "blog_ccu"
      },
      {
        "title": "Embarazo Seguro",
        "description":
            "Infórmate sobre cómo llevar un embarazo seguro y saludable",
        "imagePath": "assets/images/embarazo.png",
        "page": "BlogEmbarazoSeguroPage",
        "codigo": "blog_embarzo_seguro"
      },
      {
        "title": "Higiene íntima",
        "description":
            "Aprende sobre la importancia de la higiene íntima y cómo cuidarte",
        "imagePath": "assets/images/higiene.png",
        "page": "BlogHigieneIntimaPage",
        "codigo": "blog_higiene_intima"
      },
      {
        "title": "Violencia de género",
        "description":
            "Detecta y actúa ante la violencia de género en diferentes formas",
        "imagePath": "assets/images/violencia2.png",
        "page": "BlogViolenciaGeneroPage",
        "codigo": "blog_violencia_genero"
      },
      {
        "title": "Infección de transmisión sexual",
        "description": "Conoce las ITS, su prevención y tratamiento",
        "imagePath": "assets/images/ITS.png",
        "page": "BlogItsPage",
        "codigo": "blog_its"
      },
      {
        "title": "Infertilidad",
        "description":
            "Infórmate sobre las causas y tratamientos para la infertilidad",
        "imagePath": "assets/images/Infertilidad.png",
        "page": "BlogInfertilidadPage",
        "codigo": "blog_infertilidad"
      },
      {
        "title": "Prevención de embarazo",
        "description":
            "Aprende sobre métodos anticonceptivos y control prenatal",
        "imagePath": "assets/images/prevencion_embarazo.png",
        "page": "BlogPrevencionEmbarazoPage",
        "codigo": "blog_prevencion_embarazo"
      },
      {
        "title": "Salud sexual",
        "description": "Todo sobre la salud sexual y cómo cuidar de ti mismo",
        "imagePath": "assets/images/salud_sexual.png",
        "page": "BlogSaludSexualPage",
        "codigo": "blog_salud_sexual"
      },
      {
        "title": "VIH",
        "description": "Conoce todo sobre el VIH, su prevención y tratamiento",
        "imagePath": "assets/images/VIH.png",
        "page": "BlogVihPage",
        "codigo": "blog_vih"
      },
    ];

    var blog = blogList[index];
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () async {

          await _incrementarVistas(blog[
              "codigo"]!); 
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => getBlogPage(blog["page"] ?? ""),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              blog["imagePath"]!,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                blog["title"]!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                blog["description"]!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBlogPage(String page) {
    switch (page) {
      case "BlogAutomuestreoPage":
        return const BlogAutomuestreoPage();
      case "BlogVphPage":
        return const BlogVPHPage();
      case "BlogCancerCuelloUterinoPage":
        return const BlogCancerCuelloUterinoPage();
      case "BlogEmbarazoSeguroPage":
        return const BlogEmbarazoSeguroPage();
      case "BlogHigieneIntimaPage":
        return const BlogHigieneIntimaPage();
      case "BlogViolenciaGeneroPage":
        return const BlogViolenciaGeneroPage();
      case "BlogItsPage":
        return const BlogItsPage();
      case "BlogInfertilidadPage":
        return const BlogInfertilidadPage();
      case "BlogPrevencionEmbarazoPage":
        return const BlogPrevencionEmbarazoPage();
      case "BlogSaludSexualPage":
        return const BlogSaludSexualPage();
      case "BlogVihPage":
        return const BlogVIHPage();
      default:
        return const BlogAutomuestreoPage(); // Página predeterminada
    }
  }
}
