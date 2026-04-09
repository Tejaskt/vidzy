import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vidzy/core/component/shimmer_effect.dart';
import '../../api/model/video_model.dart';

class VideoItem extends StatefulWidget {
  final VideoModel video;
  final bool isActive;

  const VideoItem({super.key, required this.video, required this.isActive});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool isInitialized = false;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.videoUrl),
    );
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initialize();

    setState(() {
      isInitialized = true;
    });

    if (widget.isActive) {
      _controller.play();
    }

    _controller.setLooping(true);
  }

  @override
  void didUpdateWidget(covariant VideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if(oldWidget.video.videoUrl != widget.video.videoUrl){
    //   _controller.dispose();
    //   isInitialized = false;
    //   cont
    // }

    if (widget.isActive && !oldWidget.isActive) {
      _controller.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.pause();
      //_controller.dispose();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return isInitialized
    ? Stack(
            fit: StackFit.expand,
            children: [

              FittedBox(
                fit: .cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),

              Positioned(
                top: 20,
                right: 10,
                child: Card(
                  color: Colors.green.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.video.quality ?? 'N/A'),
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                left: 10,
                child: Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '@${widget.video.userName}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: .bold,
                            fontSize: 18,
                            shadows: [
                              Shadow(blurRadius: 4, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : CachedNetworkImage(
        imageUrl: widget.video.thumbnail,
        fit: .cover,
      placeholder: (_, _) => ShimmerEffect(),
    );
  }
}
