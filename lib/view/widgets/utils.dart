import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

sealed class AllowedColors {
  static const Color red = Color.fromRGBO(165, 16, 8, 1);
  static const Color blue = Color.fromRGBO(0, 40, 86, 1);
  static const Color gray = Color.fromRGBO(111, 111, 111, 1);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
}

void Function() modalLoadingDialog({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(canPop: false, child: Center(child: CircularProgressIndicator(value: null)))
  );

  return Navigator.of(context).pop;
}

Future<bool?> modalYesNoDialog({required BuildContext context, required String title, required String message, 
  required void Function() onYes, void Function()? onNo}) {
  return showDialog<bool?>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          message,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            child: const Text('Sí'),
            onPressed: () {
              onYes();
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            child: const Text('No'),
            onPressed: () {
              if (onNo != null) {
                onNo();
              }

              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

Widget buildLabel(String text) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: AllowedColors.gray,
      ),
    ),
  );
}

Widget buildDropdown(List<String> items, String? selectedItem,
    ValueChanged<String?> onChanged, String hint, {bool requiredInput = false}) {
  return DropdownButtonFormField<String>(
    value: selectedItem,
    decoration: inputDecoration(hint),
    style: TextStyle(fontSize: 15, color: AllowedColors.black),
    onChanged: onChanged,
    items: items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    validator: (value) => value == null && requiredInput ? "Campo obligatorio" : null,
  );
}

InputDecoration inputDecoration(hint, {isCalendar = false}) {
  return InputDecoration(
    prefixIcon: isCalendar ? Icon(Icons.calendar_today) : null,
    hintText: hint, // Placeholder
    hintStyle: TextStyle(
        color: AllowedColors.gray,
        fontSize: 13), // Estilo del placeholder
    errorStyle: TextStyle(fontSize: 12, color: AllowedColors.red),
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: AllowedColors.gray, width: 1.0),
      borderRadius: BorderRadius.circular(30), // Borde redondeado opcional
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: AllowedColors.gray, width: 1.5),
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: AllowedColors.gray, width: 1.0),
      borderRadius: BorderRadius.circular(30),
    ),
  );
}

// For testing purposes
Future<void> delay(Duration duration) {
  return Future.delayed(duration);
}

Future<(VideoPlayerController, ChewieController)> initializeVideoPlayer(String videoUrl, {
  bool autoPlay = false,
  bool looping = false,
}) async {
  final videoPlayerController = VideoPlayerController.asset(videoUrl);
  await videoPlayerController.initialize();

  final chewieController = ChewieController(
    videoPlayerController: videoPlayerController,
    autoPlay: autoPlay,
    looping: looping,
    showControls: true,
    aspectRatio: 16 / 9,
    allowFullScreen: true,
    allowMuting: true,
    materialProgressColors: ChewieProgressColors(
      playedColor: AllowedColors.blue,
      handleColor: Colors.blueAccent,
      backgroundColor: AllowedColors.gray,
      bufferedColor: Colors.lightBlueAccent,
    ),
  );

  return (videoPlayerController, chewieController);
}

Widget buildVideoPlayer(VideoPlayerController? playerController, ChewieController? chewie) {
  if (playerController == null) {
    return const Center(widthFactor: null, heightFactor: 3, child: CircularProgressIndicator());
  }

  final chewieController = chewie;

  if (chewieController == null) {
    return const Center(child: CircularProgressIndicator());
  } else {
    return AspectRatio(
      aspectRatio: playerController.value.aspectRatio,
      child: Chewie(controller: chewieController),
    );
  }
}