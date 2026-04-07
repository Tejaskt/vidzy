import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../api/model/video_model.dart';

class VideoItem extends StatefulWidget {
  final VideoModel video;

  const VideoItem({super.key, required this.video});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller =
    VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        controller.play();
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return controller.value.isInitialized
        ? Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.size.width,
            height: controller.value.size.height,
            child: VideoPlayer(controller),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 10,
          child: Text(
            widget.video.userName,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    )
        : const Center(child: CircularProgressIndicator());
  }
}