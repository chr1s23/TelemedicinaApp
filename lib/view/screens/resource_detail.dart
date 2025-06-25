import 'package:chatbot/view/widgets/custom_app_bar.dart';
import 'package:chatbot/view/widgets/custom_drawer.dart';
import 'package:chatbot/view/widgets/utils.dart';
import 'package:chewie/chewie.dart';
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
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initializeVideo();
  }

  void _initializeVideo() async {
    var (video, chewie) = await initializeVideoPlayer(widget.videos[_currentIndex]["videoPath"]);

    setState(() {
      _videoController = video;
      _chewieController = chewie;      
    });
  }

  void _changeVideo(int newIndex) {
    if (newIndex >= 0 && newIndex < widget.videos.length) {
      setState(() {
        _currentIndex = newIndex;
        _videoController?.pause();
        _videoController?.dispose();
        _initializeVideo();
      });
    }
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
      appBar: const CustomAppBar(),
      body: _buildBody(),
      endDrawer: const CustomDrawer(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildVideoPlayer(_videoController, _chewieController),
          const SizedBox(height: 15),
          _buildNavigationButtons(),
          const SizedBox(height: 15),
          _buildVideoDetails(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AllowedColors.blue,
            shape: CircleBorder(),
          ),
          color: AllowedColors.white,
          disabledColor: AllowedColors.gray,
          icon: const Icon(Icons.arrow_left, size: 40),
          onPressed:
              _currentIndex > 0 ? () => _changeVideo(_currentIndex - 1) : null,
        ),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AllowedColors.blue,
            shape: CircleBorder(),
          ),
          color: AllowedColors.white,
          disabledColor: AllowedColors.gray,
          icon: const Icon(Icons.arrow_right, size: 40),
          onPressed: _currentIndex < widget.videos.length - 1
              ? () => _changeVideo(_currentIndex + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildVideoDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.videos[_currentIndex]["title"]!,
          style: TextStyle(
            fontSize: 17,
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
}