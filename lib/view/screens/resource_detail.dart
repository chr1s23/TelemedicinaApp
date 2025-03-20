import 'package:chatbot/view/screens/chat.dart';
import 'package:chatbot/view/screens/dashboard.dart';
import 'package:chatbot/view/screens/notifications.dart';
import 'package:chatbot/view/screens/resources.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ResourceDetail extends StatefulWidget {
  final List<Map<String, dynamic>> videos;
  final int initialIndex;

  const ResourceDetail(
      {super.key, required this.videos, required this.initialIndex});

  @override
  State<ResourceDetail> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<ResourceDetail> {
  late VideoPlayerController _videoController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initializeVideo();
  }

  void _initializeVideo() {
    _videoController =
        VideoPlayerController.asset(widget.videos[_currentIndex]["videoPath"]!)
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });
  }

  void _changeVideo(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.videos.length) {
      setState(() {
        _currentIndex = newIndex;
        _videoController.pause();
        _videoController.dispose();
        _initializeVideo();
      });
    }
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
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Text(
        "SISA",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AllowedColors.red,
        ),
      ),
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildVideoPlayer(),
          const SizedBox(height: 15),
          _buildNavigationButtons(),
          const SizedBox(height: 15),
          _buildVideoDetails(),
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
          ? VideoPlayer(_videoController)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back,
              size: 40, color: AllowedColors.blue),
          onPressed:
              _currentIndex > 0 ? () => _changeVideo(_currentIndex - 1) : null,
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward,
              size: 40, color: AllowedColors.blue),
          onPressed: _currentIndex < widget.videos.length - 1
              ? () => _changeVideo(_currentIndex + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildVideoDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.videos[_currentIndex]["title"]!,
          style: TextStyle(
            fontSize: 15,
            color: AllowedColors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          widget.videos[_currentIndex]["description"]!,
          style:
              TextStyle(fontSize: 13, color: AllowedColors.gray),
        ),
      ],
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
            _buildNavItem(Icons.home, true,
                MaterialPageRoute(builder: (context) => Dashboard())),
            _buildNavItem(Icons.folder, false,
                MaterialPageRoute(builder: (context) => Resources())),
            _buildFloatingButton(), // Botón central del chatbot
            _buildNavItem(Icons.map, false, null),
            _buildNavItem(Icons.notifications, false,
                MaterialPageRoute(builder: (context) => Notifications())),
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
                    ? AllowedColors.blue
                    : AllowedColors.gray,
                size: 28))
      ],
    );
  }

  Widget _buildFloatingButton() {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: FloatingActionButton(
        backgroundColor: AllowedColors.blue,
        onPressed: () {
          // Acción del asistente virtual
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Chat()));
        },
        child: const Icon(Icons.smart_toy, size: 28, color: AllowedColors.white),
      ),
    );
  }
}
